{
  config,
  pkgs,
  ...
}:
let
  focus-or-back = pkgs.writeShellScriptBin "focus-or-back" ''
    target_app="$1"; shift
    state="$XDG_RUNTIME_DIR/focus-or-back-$target_app"

    focused_app=$(${pkgs.niri}/bin/niri msg --json windows \
      | ${pkgs.jq}/bin/jq -r 'first(.[] | select(.is_focused)) | .app_id')

    if [ "$focused_app" = "$target_app" ]; then
      if [ -f "$state" ]; then
        back=$(cat "$state")
        ${pkgs.niri}/bin/niri msg action focus-window --id "$back" 2>/dev/null || true
      fi
    else
      # remember the currently focused *window* id
      ${pkgs.niri}/bin/niri msg --json windows \
        | ${pkgs.jq}/bin/jq -r 'first(.[] | select(.is_focused)) | .id' > "$state"
      id=$(${pkgs.niri}/bin/niri msg --json windows \
        | ${pkgs.jq}/bin/jq -r --arg a "$target_app" 'first(.[] | select(.app_id == $a)) | .id')
      if [ -n "$id" ] && [ "$id" != "null" ]; then
        ${pkgs.niri}/bin/niri msg action focus-window --id "$id"
      else
        exec "$@"
      fi
    fi
  '';
in
{
  home.packages = [ focus-or-back ];
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "XF86AudioPlay".action.spawn = [
      "noctalia"
      "msg"
      "media"
      "toggle"
    ];
    "XF86AudioStop".action.spawn = [
      "noctalia"
      "msg"
      "media"
      "stop"
    ];
    "XF86AudioPrev".action.spawn = [
      "noctalia"
      "msg"
      "media"
      "previous"
    ];
    "XF86AudioNext".action.spawn = [
      "noctalia"
      "msg"
      "media"
      "next"
    ];

    "XF86AudioMute".action.spawn = [
      "noctalia"
      "msg"
      "volume-mute"
    ];
    "XF86AudioRaiseVolume".action.spawn = [
      "noctalia"
      "msg"
      "volume-up"
    ];
    "XF86AudioLowerVolume".action.spawn = [
      "noctalia"
      "msg"
      "volume-down"
    ];

    "XF86MonBrightnessUp".action.spawn = [
      "noctalia"
      "msg"
      "brightness-up"
    ];
    "XF86MonBrightnessDown".action.spawn = [
      "noctalia"
      "msg"
      "brightness-down"
    ];

    # screenshot
    "Print".action.screenshot = [ ];
    "Mod+Print".action.screenshot-window = [ ];
    "Mod+Ctrl+S".action.screenshot-window = [ ];
    "Mod+Shift+S".action.screenshot = [ ];

    "Mod+Q" = {
      action.close-window = { };
      repeat = false;
    };

    # spawn lockscreen
    # "Mod+Ctrl+L" = {
    #   action.spawn = [ "hyprlock" ];
    #   allow-when-locked = true;
    # };
    "Mod+Ctrl+L".action.spawn = [
      "noctalia"
      "msg"
      "session"
      "lock"
    ];

    # toggle menu
    "Shift+Ctrl+Delete".action.spawn = [
      "noctalia"
      "msg"
      "panel-toggle"
      "session"
    ];
    # "Shift+Ctrl+Delete".action.spawn = [
    #   "sh"
    #   "-c"
    #   "rofi-power-menu -theme-str 'window {width: 400px;}'"
    # ];
    # Open history
    "Mod+v".action.spawn = [
      "noctalia"
      "msg"
      "panel-toggle"
      "clipboard"
    ];
    # select from history
    # "Mod+v".action.spawn = [
    #   "sh"
    #   "-c"
    #   "pkill rofi || cliphist list | rofi -dmenu -p 'Select to copy' | cliphist decode | wl-copy"
    # ];
    # select history to delete
    # "Mod+Shift+v".action.spawn = [
    #   "sh"
    #   "-c"
    #   "pkill rofi || cliphist list | rofi -dmenu -p 'Select to delete' | cliphist delete"
    # ];
    # delete last entry from cliphist history
    # "Mod+Delete".action.spawn = [
    #   "sh"
    #   "-c"
    #   "cliphist list | cliphist delete"
    # ];

    "Mod+G".action = switch-preset-column-width;
    # "Mod+Shift+G".action = switch-preset-window-height;
    # "Mod+Ctrl+R".action = reset-window-height;
    "Mod+F".action = maximize-column;
    "Mod+Ctrl+F".action = toggle-window-floating;
    "Mod+Shift+F".action = fullscreen-window;
    # "Mod+Space".action.spawn = [
    #   "sh"
    #   "-c"
    #   "pkill rofi || rofi -show drun -theme-str 'window {width: 400px;}'"
    # ];
    "Mod+Space".action.spawn = [
      "noctalia"
      "msg"
      "panel-toggle"
      "launcher"
    ];
    "Mod+Return".action = spawn "footclient";
    "Mod+W".action = toggle-column-tabbed-display;
    "Mod+Shift+Q".action = quit;
    "Mod+Shift+X".action.spawn = [
      "loginctl"
      "lock-session"
    ];

    "Mod+S".action.spawn = [
      "focus-or-back"
      # "Spotify"
      "spotify"
    ];

    "Mod+I".action.spawn = [
      "focus-or-back"
      "vesktop"
      # "spotify"
    ];

    "Mod+Shift+P".action = consume-window-into-column;
    "Mod+Shift+K".action = expel-window-from-column;
    "Mod+C".action = center-window;
    "Mod+Tab".action = switch-focus-between-floating-and-tiling;

    "Mod+Alt+Y".action = set-column-width "-10%";
    "Mod+Alt+E".action = set-column-width "+10%";
    "Mod+Shift+Alt+Y".action = set-window-height "-10%";
    "Mod+Shift+Alt+E".action = set-window-height "+10%";
    "Mod+O".action = toggle-overview;

    "Mod+Y".action = focus-column-or-monitor-left;
    "Mod+E".action = focus-column-or-monitor-right;
    "Mod+H".action = focus-window-or-workspace-down;
    "Mod+A".action = focus-window-or-workspace-up;
    "Mod+Comma".action = focus-column-left-or-last;
    "Mod+Period".action = focus-column-right-or-first;
    "Mod+Ctrl+Y".action = focus-monitor-left;
    "Mod+Ctrl+E".action = focus-monitor-right;
    "Mod+Ctrl+A".action = focus-workspace-up;
    "Mod+Ctrl+H".action = focus-workspace-down;

    "Mod+Shift+Y".action = move-column-left-or-to-monitor-left;
    "Mod+Shift+E".action = move-column-right-or-to-monitor-right;
    "Mod+Shift+A".action = move-window-up-or-to-workspace-up;
    "Mod+Shift+H".action = move-window-down-or-to-workspace-down;
    "Mod+Shift+Ctrl+Y".action = move-window-to-monitor-left;
    "Mod+Shift+Ctrl+E".action = move-window-to-monitor-right;
    "Mod+Shift+Ctrl+H".action = move-window-to-workspace-down;
    "Mod+Shift+Ctrl+A".action = move-window-to-workspace-up;

    "Mod+1".action.focus-workspace = "1";
    "Mod+2".action.focus-workspace = "2";
    "Mod+3".action.focus-workspace = "3";
    "Mod+4".action.focus-workspace = "4";
    "Mod+5".action.focus-workspace = "5";
    "Mod+6".action.focus-workspace = "6";
    "Mod+7".action.focus-workspace = "7";
    "Mod+8".action.focus-workspace = "8";
    "Mod+9".action.focus-workspace = "9";
    "Mod+0".action.focus-workspace = "stuff";
    "Mod+Shift+1".action.move-column-to-workspace = "1";
    "Mod+Shift+2".action.move-column-to-workspace = "2";
    "Mod+Shift+3".action.move-column-to-workspace = "3";
    "Mod+Shift+4".action.move-column-to-workspace = "4";
    "Mod+Shift+5".action.move-column-to-workspace = "5";
    "Mod+Shift+6".action.move-column-to-workspace = "6";
    "Mod+Shift+7".action.move-column-to-workspace = "7";
    "Mod+Shift+8".action.move-column-to-workspace = "8";
    "Mod+Shift+9".action.move-column-to-workspace = "9";
    "Mod+Shift+0".action.move-column-to-workspace = "stuff";
  };
}
