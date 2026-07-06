use std::collections::{BTreeMap, BTreeSet, HashSet};
use std::io::{BufRead, BufReader};
use std::process::{Command, Stdio};

use serde_json::Value;

/// Workspaces (by name) on which every window's column is forced to 100%
/// width, regardless of how many windows are present. Read once from the
/// NIRI_WS_TARGETS env var as a comma-separated list (e.g. "1,2,3,stuff").
/// Unset or empty means pure solo-maximize behavior everywhere.
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

/// Width to restore when a window is no longer solo / leaves a target
/// workspace. Override with NIRI_RESTORE_WIDTH (e.g. "33.333%").
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
    /// windows whose column we've set to 100%
    maximized: BTreeSet<u64>,
    /// currently focused window, per the event stream
    focused: Option<u64>,
}

impl State {
    fn target_workspace_ids(&self) -> HashSet<u64> {
        self.workspace_names
            .iter()
            .filter_map(|(id, name)| {
                let name = name.as_deref()?;
                target_ws_names()
                    .iter()
                    .any(|t| t == name)
                    .then_some(*id)
            })
            .collect()
    }

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
            // Full snapshot of all windows.
            if let Some(list) = payload.get("windows").and_then(Value::as_array) {
                self.windows.clear();
                for w in list {
                    self.upsert_window(w);
                }
                self.maximized.retain(|id| self.windows.contains_key(id));
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
                self.maximized.remove(&id);
                if self.focused == Some(id) {
                    self.focused = None;
                }
            }
        } else if let Some(payload) = obj.get("WindowFocusChanged") {
            self.focused = payload.get("id").and_then(Value::as_u64);
        }
        // Everything else (workspace activation, keyboard layouts, ...) is
        // irrelevant.
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
        if w.get("is_focused").and_then(Value::as_bool) == Some(true) {
            self.focused = Some(id);
        }
    }

    fn enforce(&mut self) {
        let targets = self.target_workspace_ids();

        // Count tiled windows per workspace; floating windows don't affect
        // whether a tiled window is "solo".
        let mut tiled_count: BTreeMap<u64, usize> = BTreeMap::new();
        for info in self.windows.values() {
            if info.floating {
                continue;
            }
            if let Some(ws) = info.ws {
                *tiled_count.entry(ws).or_insert(0) += 1;
            }
        }

        let mut to_maximize = Vec::new();
        let mut to_restore = Vec::new();

        for (&id, info) in &self.windows {
            if info.floating {
                // Never resize floating windows; drop stale bookkeeping if a
                // maximized window went floating.
                self.maximized.remove(&id);
                continue;
            }
            let desired = info.ws.is_some_and(|ws| {
                targets.contains(&ws) || tiled_count.get(&ws) == Some(&1)
            });
            let is_max = self.maximized.contains(&id);
            if desired && !is_max {
                to_maximize.push(id);
            } else if !desired && is_max {
                to_restore.push(id);
            }
        }

        if to_maximize.is_empty() && to_restore.is_empty() {
            return;
        }

        for &id in &to_maximize {
            set_column_width_for_window(id, "100%");
            self.maximized.insert(id);
        }
        for &id in &to_restore {
            set_column_width_for_window(id, restore_width());
            self.maximized.remove(&id);
        }

        // Resizing required focusing each affected window; put focus back
        // where the user had it.
        if let Some(f) = self.focused {
            if self.windows.contains_key(&f) {
                niri_action(&["focus-window", "--id", &f.to_string()]);
            }
        }
    }
}

/// Path to the niri binary. Set NIRI_BIN to pin the exact compositor
/// package (avoids IPC version mismatch); falls back to PATH lookup.
fn niri_bin() -> &'static str {
    use std::sync::OnceLock;
    static BIN: OnceLock<String> = OnceLock::new();
    BIN.get_or_init(|| std::env::var("NIRI_BIN").unwrap_or_else(|_| "niri".to_string()))
}

fn niri_action(args: &[&str]) {
    let _ = Command::new(niri_bin())
        .arg("msg")
        .arg("action")
        .args(args)
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status();
}

/// `set-column-width` acts on the focused column, so focus the window first.
fn set_column_width_for_window(id: u64, width: &str) {
    niri_action(&["focus-window", "--id", &id.to_string()]);
    niri_action(&["set-column-width", width]);
}

fn main() -> std::io::Result<()> {
    let mut child = Command::new(niri_bin())
        .args(["msg", "--json", "event-stream"])
        .stdout(Stdio::piped())
        .stderr(Stdio::null())
        .spawn()?;

    let stdout = child.stdout.take().expect("stdout was piped");
    let reader = BufReader::new(stdout);

    let mut state = State::default();

    for line in reader.lines() {
        let line = line?;
        let line = line.trim();
        if line.is_empty() {
            continue;
        }
        let Ok(event) = serde_json::from_str::<Value>(line) else {
            continue;
        };
        state.handle_event(&event);
        state.enforce();
    }

    // Event stream ended (niri exited or the socket dropped).
    // Exit non-zero so systemd's Restart=always brings us back up.
    let _ = child.wait();
    std::process::exit(1);
}
