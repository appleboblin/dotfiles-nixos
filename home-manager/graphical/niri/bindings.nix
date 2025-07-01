{
  lib,
  pkgs,
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
    # "Mod+Shift+S".action.spawn = [
    #   "sh"
    #   "-c"
    #   "grimblast --notify copysave area ~/Pictures/Screenshots/screenshot_%Y%m%d_%H%M%S).png"
    # ];

    "Mod+Q".action.close-window = [ ];
    "Shift+Ctrl+Delete".action.spawn = [
      "sh"
      "-c"
      "rofi-power-menu -theme-str 'window {width: 400px;}'"
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

    "Mod+Shift+H".action = consume-window-into-column;
    "Mod+Shift+K".action = expel-window-from-column;
    "Mod+C".action = center-window;
    "Mod+Tab".action = switch-focus-between-floating-and-tiling;

    "Mod+Minus".action = set-column-width "-10%";
    "Mod+Equal".action = set-column-width "+10%";
    "Mod+Shift+Equal".action = set-window-height "-10%";
    "Mod+Shift+Minus".action = set-window-height "+10%";
    "Mod+O".action = toggle-overview;

    "Mod+M".action = focus-column-or-monitor-left;
    "Mod+I".action = focus-column-or-monitor-right;
    "Mod+N".action = focus-window-or-workspace-down;
    "Mod+E".action = focus-window-or-workspace-up;
    "Mod+Comma".action = focus-column-left-or-last;
    "Mod+Period".action = focus-column-right-or-first;
    "Mod+Ctrl+M".action = focus-monitor-left;
    "Mod+Ctrl+I".action = focus-monitor-right;
    "Mod+Ctrl+E".action = focus-workspace-up;
    "Mod+Ctrl+N".action = focus-workspace-down;
    "Mod+Ctrl+1".action = focus-monitor "DP-1";
    "Mod+Ctrl+2".action = focus-monitor "DP-2";
    "Mod+Ctrl+3".action = focus-monitor "HDMI-A-1";
    # "Mod+Home".action = focus-column-first;
    # "Mod+End".action = focus-column-last;
    # "Mod+Shift+Home".action = move-column-to-first;
    # "Mod+Shift+End".action = move-column-to-last;

    "Mod+Shift+M".action = move-column-left-or-to-monitor-left;
    "Mod+Shift+I".action = move-column-right-or-to-monitor-right;
    "Mod+Shift+E".action = move-window-up-or-to-workspace-up;
    "Mod+Shift+N".action = move-window-down-or-to-workspace-down;
    "Mod+Shift+Ctrl+M".action = move-window-to-monitor-left;
    "Mod+Shift+Ctrl+I".action = move-window-to-monitor-right;
    "Mod+Shift+Ctrl+N".action = move-window-to-workspace-down;
    "Mod+Shift+Ctrl+E".action = move-window-to-workspace-up;
    "Mod+Shift+Ctrl+1".action.move-window-to-monitor = "DP-1";
    "Mod+Shift+Ctrl+2".action.move-window-to-monitor = "DP-2";
    "Mod+Shift+Ctrl+3".action.move-window-to-monitor = "HDMI-A-1";

    "Mod+1".action.focus-workspace = 1;
    "Mod+2".action.focus-workspace = 2;
    "Mod+3".action.focus-workspace = 3;
    "Mod+4".action.focus-workspace = 4;
    "Mod+5".action.focus-workspace = 5;
    "Mod+6".action.focus-workspace = 6;
    "Mod+7".action.focus-workspace = 7;
    "Mod+8".action.focus-workspace = 8;
    "Mod+9".action.focus-workspace = 9;
    "Mod+Shift+1".action.move-column-to-workspace = 1;
    "Mod+Shift+2".action.move-column-to-workspace = 2;
    "Mod+Shift+3".action.move-column-to-workspace = 3;
    "Mod+Shift+4".action.move-column-to-workspace = 4;
    "Mod+Shift+5".action.move-column-to-workspace = 5;
    "Mod+Shift+6".action.move-column-to-workspace = 6;
    "Mod+Shift+7".action.move-column-to-workspace = 7;
    "Mod+Shift+8".action.move-column-to-workspace = 8;
    "Mod+Shift+9".action.move-column-to-workspace = 9;
  };
}
