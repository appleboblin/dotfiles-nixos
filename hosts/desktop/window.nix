{ config, pkgs, ... }:

let
  niriFullscreenWs2 = pkgs.writeText "niri-fullscreen-ws2.py" ''
    #!/usr/bin/env python3
    import json
    import subprocess
    import sys
    from typing import Any

    TARGET_WS_NAMES = {"W0", "W1", "W2", "W9"}

    workspaces_by_id: dict[int, dict[str, Any]] = {}
    windows_by_id: dict[int, dict[str, Any]] = {}

    # Track columns/windows we've already maximized while on ws2
    maximized_ids: set[int] = set()


    def as_int(x: Any) -> int | None:
        try:
            return int(x)
        except Exception:
            return None


    def looks_like_workspace(d: Any) -> bool:
        return isinstance(d, dict) and "id" in d and (
            "idx" in d or "index" in d or "name" in d or "output" in d or "reference" in d
        )


    def looks_like_window(d: Any) -> bool:
        return isinstance(d, dict) and "id" in d and (
            "workspace_id" in d or "app_id" in d or "title" in d
        )


    def extract_workspace_items(obj: Any) -> list[dict[str, Any]]:
        found: list[dict[str, Any]] = []

        def walk(v: Any) -> None:
            if isinstance(v, list):
                if v and all(looks_like_workspace(i) for i in v):
                    found.extend(v)  # type: ignore[arg-type]
                    return
                for item in v:
                    walk(item)
            elif isinstance(v, dict):
                if looks_like_workspace(v):
                    found.append(v)
                for sub in v.values():
                    walk(sub)

        walk(obj)
        return found


    def extract_window_items(obj: Any) -> list[dict[str, Any]]:
        found: list[dict[str, Any]] = []

        def walk(v: Any) -> None:
            if isinstance(v, list):
                if v and all(looks_like_window(i) for i in v):
                    found.extend(v)  # type: ignore[arg-type]
                    return
                for item in v:
                    walk(item)
            elif isinstance(v, dict):
                if looks_like_window(v):
                    found.append(v)
                for sub in v.values():
                    walk(sub)

        walk(obj)
        return found


    def maybe_workspace_index(ws: dict[str, Any]) -> int | None:
        for key in ("idx", "index", "workspace_index", "index_in_output"):
            if key in ws:
                return as_int(ws[key])

        ref = ws.get("reference")
        if isinstance(ref, dict):
            for key in ("Index", "index"):
                if key in ref:
                    return as_int(ref[key])

        return None


    def refresh_state_from_event(event: Any) -> None:
        for ws in extract_workspace_items(event):
            wid = as_int(ws.get("id"))
            if wid is None:
                continue
            old = workspaces_by_id.get(wid, {})
            old.update(ws)
            workspaces_by_id[wid] = old

        for w in extract_window_items(event):
            wid = as_int(w.get("id"))
            if wid is None:
                continue
            old = windows_by_id.get(wid, {})
            old.update(w)
            windows_by_id[wid] = old

        # best-effort cleanup for closed windows
        def walk_for_removed_ids(v: Any) -> list[int]:
            removed: list[int] = []
            if isinstance(v, dict):
                for k, payload in v.items():
                    lk = str(k).lower()
                    if any(word in lk for word in ("closed", "removed", "destroyed")) and isinstance(payload, dict):
                        rid = as_int(payload.get("id"))
                        if rid is not None:
                            removed.append(rid)
                    removed.extend(walk_for_removed_ids(payload))
            elif isinstance(v, list):
                for item in v:
                    removed.extend(walk_for_removed_ids(item))
            return removed

        for rid in walk_for_removed_ids(event):
            windows_by_id.pop(rid, None)
            maximized_ids.discard(rid)

    def target_workspace_ids() -> set[int]:
        out: set[int] = set()
        for wsid, ws in workspaces_by_id.items():
            name = ws.get("name")
            if isinstance(name, str) and name in TARGET_WS_NAMES:
                out.add(wsid)
        return out

    def niri_action(*args: str) -> None:
        subprocess.run(
            ["niri", "msg", "action", *args],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )


    def maximize_window_column(window_id: int) -> None:
        # maximize-column acts on the focused column, so focus the window first
        niri_action("focus-window", "--id", str(window_id))
        niri_action("set-column-width", "100%")
        # niri_action("maximize-column")


    def enforce() -> None:
        targets = target_workspace_ids()
        if not targets:
            return

        current_ids = set(windows_by_id.keys())
        maximized_ids.intersection_update(current_ids)

        for wid, w in windows_by_id.items():
            wsid = as_int(w.get("workspace_id"))

            if wsid in targets:
                if wid not in maximized_ids:
                    maximize_window_column(wid)
                    maximized_ids.add(wid)
            else:
                if wid in maximized_ids:
                    niri_action("focus-window", "--id", str(wid))
                    niri_action("set-column-width", "50%")
                    maximized_ids.discard(wid)

    def main() -> None:
        proc = subprocess.Popen(
            ["niri", "msg", "--json", "event-stream"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1,
        )

        if proc.stdout is None:
            print("Failed to open niri event stream.", file=sys.stderr)
            sys.exit(1)

        for line in proc.stdout:
            line = line.strip()
            if not line:
                continue
            try:
                event = json.loads(line)
            except json.JSONDecodeError:
                continue

            refresh_state_from_event(event)
            enforce()


    if __name__ == "__main__":
        main()

  '';
in
{
  # Put the script in ~/.local/bin
  home.file.".local/bin/niri-fullscreen-ws2.py" = {
    text = builtins.readFile niriFullscreenWs2;
    executable = true;
  };

  systemd.user.services.niri-fullscreen-ws2 = {
    Unit = {
      Description = "Fullscreen windows on niri workspace 2";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.python3}/bin/python3 ${config.home.homeDirectory}/.local/bin/niri-fullscreen-ws2.py";
      Restart = "always";
      RestartSec = 1;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
