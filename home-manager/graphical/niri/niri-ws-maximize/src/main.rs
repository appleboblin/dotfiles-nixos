use std::collections::{BTreeMap, BTreeSet, HashSet};
use std::io::{BufRead, BufReader};
use std::process::{Command, Stdio};

use serde_json::Value;

/// Workspaces (by name) on which every window's column is forced to 100%
/// width, regardless of how many windows are present. Read once from the
/// NIRI_WS_TARGETS env var as a comma-separated list (e.g. "1,2,3,stuff").
/// Unset or empty means pure solo-maximize behavior everywhere.
///
/// Note: entries match workspace *names* only. "1" matches a workspace
/// literally named "1", not the workspace at index 1.
fn target_ws_names() -> &'static [String] {
    use std::sync::OnceLock;
    static NAMES: OnceLock<Vec<String>> = OnceLock::new();
    NAMES.get_or_init(|| {
        std::env::var("NIRI_WS_TARGETS")
            .unwrap_or_default()
            .split(',')
            .map(str::trim)
            .filter(|s| !s.is_empty())
            .map(String::from)
            .collect()
    })
}

/// Width to restore when a window leaves the desired-maximized set.
/// Override with NIRI_RESTORE_WIDTH (e.g. "33.333%").
fn restore_width() -> &'static str {
    use std::sync::OnceLock;
    static WIDTH: OnceLock<String> = OnceLock::new();
    WIDTH.get_or_init(|| {
        std::env::var("NIRI_RESTORE_WIDTH").unwrap_or_else(|_| "50%".to_string())
    })
}

struct WindowInfo {
    /// workspace id (None while unmapped)
    ws: Option<u64>,
    floating: bool,
}

#[derive(Default)]
struct State {
    /// workspace id -> workspace name (if named)
    workspace_names: BTreeMap<u64, Option<String>>,
    windows: BTreeMap<u64, WindowInfo>,
    /// The desired-maximized set from the previous enforce pass. Purely a
    /// diff base for deciding which windows to resize; recomputed from
    /// window state every pass, so it can't drift from reality.
    prev_desired: BTreeSet<u64>,
}

impl State {
    /// Handle one event from `niri msg --json event-stream`.
    ///
    /// Events are externally tagged, e.g.
    /// `{"WindowOpenedOrChanged":{"window":{...}}}`.
    fn handle_event(&mut self, event: &Value) {
        let Some(obj) = event.as_object() else { return };

        if let Some(payload) = obj.get("WorkspacesChanged") {
            // Full snapshot of all workspaces.
            if let Some(list) = payload.get("workspaces").and_then(Value::as_array) {
                self.workspace_names.clear();
                for ws in list {
                    if let Some(id) = ws.get("id").and_then(Value::as_u64) {
                        let name = ws.get("name").and_then(Value::as_str).map(String::from);
                        self.workspace_names.insert(id, name);
                    }
                }
            }
        } else if let Some(payload) = obj.get("WindowsChanged") {
            // Full snapshot of all windows. Also reset the diff base so the
            // next pass re-issues widths from scratch (harmless no-ops for
            // windows already at the right size); this self-heals drift
            // after a service restart or a failed action.
            if let Some(list) = payload.get("windows").and_then(Value::as_array) {
                self.windows.clear();
                self.prev_desired.clear();
                for w in list {
                    self.upsert_window(w);
                }
            }
        } else if let Some(payload) = obj.get("WindowOpenedOrChanged") {
            // Also fires when a window moves to another workspace or
            // toggles floating.
            if let Some(w) = payload.get("window") {
                self.upsert_window(w);
            }
        } else if let Some(payload) = obj.get("WindowClosed") {
            if let Some(id) = payload.get("id").and_then(Value::as_u64) {
                self.windows.remove(&id);
                self.prev_desired.remove(&id);
            }
        }
        // Everything else (focus changes, workspace activation, layout
        // changes, ...) is irrelevant.
    }

    fn upsert_window(&mut self, w: &Value) {
        let Some(id) = w.get("id").and_then(Value::as_u64) else { return };
        let info = WindowInfo {
            ws: w.get("workspace_id").and_then(Value::as_u64),
            floating: w
                .get("is_floating")
                .and_then(Value::as_bool)
                .unwrap_or(false),
        };
        self.windows.insert(id, info);
    }

    /// Compute which tiled windows should be at 100% right now: any window
    /// on a target workspace, or the only tiled window on its workspace.
    fn desired_maximized(&self) -> BTreeSet<u64> {
        let targets: HashSet<u64> = self
            .workspace_names
            .iter()
            .filter_map(|(id, name)| {
                let name = name.as_deref()?;
                target_ws_names().iter().any(|t| t == name).then_some(*id)
            })
            .collect();

        // Floating windows don't count toward whether a tiled window is
        // "solo", and are never resized themselves.
        let mut tiled_count: BTreeMap<u64, usize> = BTreeMap::new();
        for info in self.windows.values() {
            if let (false, Some(ws)) = (info.floating, info.ws) {
                *tiled_count.entry(ws).or_insert(0) += 1;
            }
        }

        self.windows
            .iter()
            .filter(|(_, info)| !info.floating)
            .filter_map(|(&id, info)| {
                let ws = info.ws?;
                (targets.contains(&ws) || tiled_count.get(&ws) == Some(&1)).then_some(id)
            })
            .collect()
    }

    fn enforce(&mut self) {
        let desired = self.desired_maximized();
        for &id in desired.difference(&self.prev_desired) {
            set_width(id, "100%");
        }
        for &id in self.prev_desired.difference(&desired) {
            set_width(id, restore_width());
        }
        self.prev_desired = desired;
    }
}

/// Path to the niri binary. Set NIRI_BIN to pin the exact compositor
/// package (avoids IPC version mismatch); falls back to PATH lookup.
fn niri_bin() -> &'static str {
    use std::sync::OnceLock;
    static BIN: OnceLock<String> = OnceLock::new();
    BIN.get_or_init(|| std::env::var("NIRI_BIN").unwrap_or_else(|_| "niri".to_string()))
}

/// Set a window's column width by id. `set-window-width --id` targets the
/// window directly, so no focus juggling is needed. stderr flows through to
/// ours (journald picks it up for user services).
fn set_width(id: u64, width: &str) {
    let args = ["set-window-width", "--id", &id.to_string(), width];
    match Command::new(niri_bin())
        .args(["msg", "action"])
        .args(args)
        .stdout(Stdio::null())
        .status()
    {
        Ok(status) if !status.success() => eprintln!("niri action {args:?} failed: {status}"),
        Err(e) => eprintln!("failed to spawn {}: {e}", niri_bin()),
        _ => {}
    }
}

fn main() -> std::io::Result<()> {
    let mut child = Command::new(niri_bin())
        .args(["msg", "--json", "event-stream"])
        .stdout(Stdio::piped())
        .spawn()?;

    let stdout = child.stdout.take().expect("stdout was piped");
    let mut state = State::default();

    for line in BufReader::new(stdout).lines() {
        let Ok(line) = line else { break };
        let line = line.trim();
        if line.is_empty() {
            continue;
        }
        if let Ok(event) = serde_json::from_str::<Value>(line) {
            state.handle_event(&event);
            state.enforce();
        }
    }

    // Event stream ended. Distinguish a clean compositor shutdown (session
    // ending -- exit 0 so Restart=on-failure leaves us alone) from an
    // unexpected stream death (exit 1 so systemd restarts us).
    match child.wait() {
        Ok(status) if status.success() => Ok(()),
        Ok(status) => {
            eprintln!("niri event-stream exited: {status}");
            std::process::exit(1);
        }
        Err(e) => {
            eprintln!("failed to wait on niri event-stream: {e}");
            std::process::exit(1);
        }
    }
}
