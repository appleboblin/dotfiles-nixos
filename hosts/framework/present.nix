{ config, pkgs, ... }:
let
  umbriel = config.programs.umbriel.package;
  noctalia = config.programs.noctalia.package;

  # umbriel ignores wl-mirror's fullscreen-on-output request and has no
  # move-to-named-output action, so place the mirror with one rule per
  # connector it could be on (AMD board exposes DP-1..DP-8, docks add more)
  connectors =
    builtins.genList (i: "DP-${toString (i + 1)}") 16
    ++ builtins.genList (i: "HDMI-A-${toString (i + 1)}") 4;

  # present cycle|off|extend|mirror|status
  # off -> extend (preview of the external output on eDP-1)
  #     -> mirror (eDP-1 fullscreen on the external output) -> off
  # wl-mirror runs as the transient unit present-mirror; present-watch
  # runs only while a mode is active and calls `present off` on unplug.
  present = pkgs.writeShellApplication {
    name = "present";
    runtimeInputs = [
      pkgs.jq
      pkgs.util-linux
      pkgs.systemd
      umbriel
      noctalia
    ];
    text = ''
      state="$XDG_RUNTIME_DIR/present-mode" # "<mode> <output>"
      exec 9>"$XDG_RUNTIME_DIR/present.lock"
      flock 9

      # first real (non-virtual) external output by name
      external() {
        umbriel outputs --json | jq -r '
          [.[] | select(.name != "eDP-1" and .config_name != null) | .name]
          | sort | .[0] // empty'
      }

      mirror() { # title, wl-mirror args...
        local title="$1" prev; shift
        prev=$(umbriel focused-window --json 2>/dev/null | jq -r '.id // empty')
        systemctl --user stop present-mirror.service 2>/dev/null || true
        systemd-run --user --quiet --collect --unit=present-mirror \
          ${pkgs.wl-mirror}/bin/wl-mirror --title "$title" "$@"
        # wl-mirror gets no frames if it opens unfocused (default_focused =
        # false), so let it take focus, then hand focus back
        for _ in $(seq 30); do
          [ "$(umbriel focused-window --json 2>/dev/null | jq -r '.title // empty')" = "$title" ] && break
          sleep 0.1
        done
        if [ -n "$prev" ]; then umbriel msg window-focus "$prev" >/dev/null 2>&1 || true; fi
      }

      off() {
        systemctl --user stop present-mirror.service 2>/dev/null || true
        if [ -f "$state" ]; then
          rm -f "$state"
          noctalia msg caffeine-disable || true
          noctalia msg notification-dnd-set off || true
        fi
        # last: may be stopping the unit we're running in
        systemctl --user stop --no-block present-watch.service
      }

      enter() { # mode, output
        if [ ! -f "$state" ]; then
          noctalia msg caffeine-enable || true
          noctalia msg notification-dnd-set on || true
        fi
        echo "$1 $2" > "$state"
        case "$1" in
          extend) mirror present-preview "$2" ;;
          # the output is in the title so a window rule can place it there
          mirror) mirror "present-mirror $2" --fullscreen-output "$2" eDP-1 ;;
        esac
        systemctl --user start present-watch.service
      }

      current=off
      if [ -f "$state" ]; then
        read -r current current_out < "$state" || true
        # stale state (crash, re-login): wl-mirror gone or output unplugged
        if ! systemctl --user -q is-active present-mirror.service ||
          ! umbriel outputs --json |
            jq -e --arg o "''${current_out:-}" 'any(.[]; .name == $o)' >/dev/null; then
          off
          current=off
        fi
      fi

      cmd="''${1:-cycle}"
      case "$cmd" in
        status) echo "$current"; exit 0 ;;
        off) off; exit 0 ;;
        cycle)
          case "$current" in
            off) cmd=extend ;;
            extend) cmd=mirror ;;
            mirror) off; exit 0 ;;
          esac ;;
        extend|mirror) ;;
        *) echo "usage: present [cycle|off|extend|mirror|status]" >&2; exit 2 ;;
      esac

      # keep presenting on the same output when switching modes
      if [ "$current" = off ]; then out=$(external); else out="$current_out"; fi
      [ -n "$out" ] || exit 0 # no external output: stay off
      enter "$cmd" "$out"
    '';
  };

  present-watch = pkgs.writeShellApplication {
    name = "present-watch";
    runtimeInputs = [
      pkgs.jq
      umbriel
      present
    ];
    text = ''
      read -r _ out < "$XDG_RUNTIME_DIR/present-mode" || exit 0
      umbriel subscribe outputs |
        jq --unbuffered -r --arg o "$out" 'any(.data[]; .name == $o)' |
        while read -r connected; do
          if [ "$connected" = false ]; then
            present off
            exit 0
          fi
        done
    '';
  };
in
{
  home.packages = [ present ];

  # started by `present` only while presenting, so nothing runs otherwise
  systemd.user.services.present-watch = {
    Unit = {
      Description = "Leave presentation mode when the external output disconnects";
      PartOf = [ "graphical-session.target" ];
    };
    Service.ExecStart = "${present-watch}/bin/present-watch";
  };

  programs.umbriel.settings = {
    keybinds."Mod+P" = {
      action = "spawn present cycle";
      repeat = false;
    };

    window_rule = [
      {
        match.title = "^present-preview$";
        default_output = "eDP-1";
        default_floating = true;
        default_pinned = true;
        default_floating_size_px = {
          width = 480;
          height = 270;
        };
        default_position = {
          x = 16;
          y = 16;
          anchor = "bottom_right";
        };
      }
    ]
    ++ map (o: {
      match.title = "^present-mirror ${o}$";
      default_output = o;
      default_fullscreen = true;
    }) connectors;
  };
}
