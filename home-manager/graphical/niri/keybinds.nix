{
  config,
  ...
}:
{
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "XF86AudioMute".action = spawn "swayosd-client" "--output-volume=mute-toggle";
    "XF86AudioMicMute".action = spawn "swayosd-client" "--input-volume=mute-toggle";

    "XF86AudioPlay".action.spawn = [
      "playerctl"
      "play-pause"
    ];
    "XF86AudioStop".action.spawn = [
      "playerctl"
      "pause"
    ];
    "XF86AudioPrev".action.spawn = [
      "playerctl"
      "previous"
    ];
    "XF86AudioNext".action.spawn = [
      "playerctl"
      "next"
    ];

    "XF86AudioRaiseVolume".action.spawn = [
      "swayosd-client"
      "--output-volume=raise"
    ];
    "XF86AudioLowerVolume".action.spawn = [
      "swayosd-client"
      "--output-volume=lower"
    ];

    "XF86MonBrightnessUp".action.spawn = [
      "swayosd-client"
      "--brightness=raise"
    ];
    "XF86MonBrightnessDown".action.spawn = [
      "swayosd-client"
      "--brightness=lower"
    ];

    # screenshot
    "Mod+Print".action = screenshot-window;
    "Mod+Shift+S".action = screenshot;

    "Mod+B" = {
      action.close-window = { };
      repeat = false;
    };

    # toggle menu
    "Shift+Ctrl+Delete".action.spawn = [
      "sh"
      "-c"
      "rofi-power-menu -theme-str 'window {width: 400px;}'"
    ];
    # select from history
    "Mod+v".action.spawn = [
      "sh"
      "-c"
      "pkill rofi || cliphist list | rofi -dmenu -p 'Select to copy' | cliphist decode | wl-copy"
    ];
    # select history to delete
    "Mod+Shift+v".action.spawn = [
      "sh"
      "-c"
      "pkill rofi || cliphist list | rofi -dmenu -p 'Select to delete' | cliphist delete"
    ];
    # delete last entry from cliphist history
    "Mod+Delete".action.spawn = [
      "sh"
      "-c"
      "cliphist list | cliphist delete"
    ];

    "Mod+G".action = switch-preset-column-width;
    "Mod+Shift+G".action = switch-preset-window-height;
    "Mod+Ctrl+R".action = reset-window-height;
    "Mod+F".action = maximize-column;
    "Mod+Ctrl+F".action = toggle-window-floating;
    "Mod+Shift+F".action = fullscreen-window;
    "Mod+Space".action.spawn = [
      "sh"
      "-c"
      "pkill rofi || rofi -show drun -theme-str 'window {width: 400px;}'"
    ];
    "Mod+Return".action = spawn "footclient";
    "Mod+W".action = toggle-column-tabbed-display;

    "Mod+Shift+P".action = consume-window-into-column;
    "Mod+Shift+K".action = expel-window-from-column;
    "Mod+C".action = center-window;
    "Mod+Tab".action = switch-focus-between-floating-and-tiling;
    "Alt+S".action.focus-workspace = "Wmusic";

    "Mod+Minus".action = set-column-width "-10%";
    "Mod+Equal".action = set-column-width "+10%";
    "Mod+Shift+Equal".action = set-window-height "-10%";
    "Mod+Shift+Minus".action = set-window-height "+10%";
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

    "Mod+1".action.focus-workspace = "W0";
    "Mod+2".action.focus-workspace = "W1";
    "Mod+3".action.focus-workspace = "W2";
    "Mod+4".action.focus-workspace = "W3";
    "Mod+5".action.focus-workspace = "W4";
    "Mod+6".action.focus-workspace = "W5";
    "Mod+7".action.focus-workspace = "W6";
    "Mod+8".action.focus-workspace = "W7";
    "Mod+9".action.focus-workspace = "W8";
    "Mod+0".action.focus-workspace = "W9";
    "Mod+Shift+1".action.move-column-to-workspace = "W0";
    "Mod+Shift+2".action.move-column-to-workspace = "W1";
    "Mod+Shift+3".action.move-column-to-workspace = "W2";
    "Mod+Shift+4".action.move-column-to-workspace = "W3";
    "Mod+Shift+5".action.move-column-to-workspace = "W4";
    "Mod+Shift+6".action.move-column-to-workspace = "W5";
    "Mod+Shift+7".action.move-column-to-workspace = "W6";
    "Mod+Shift+8".action.move-column-to-workspace = "W7";
    "Mod+Shift+9".action.move-column-to-workspace = "W8";
    "Mod+Shift+0".action.move-column-to-workspace = "W9";
  };
}
