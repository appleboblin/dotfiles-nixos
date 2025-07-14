{
  lib,
  ...
}:
let
  monitors = import ./monitors.nix;
  wpPath = ../../home-manager/graphical/WP_Laser_Up-2560x1440_00229.jpg;
in
{
  imports = [
    ./waybar.nix
  ];

  services = {
    hypridle.settings = {
      listener = lib.mkDefault [
        {
          timeout = 10 * 60;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 20 * 60;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 30 * 60;
          on-timeout = "systemctl suspend";
        }
      ];
    };

    hyprpaper.settings = {
      wallpaper = [
        "${monitors.left},${wpPath}"
        "${monitors.middle},${wpPath}"
        "${monitors.right},${wpPath}"
      ];
    };
  };

  # hyprland config
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "${monitors.left}, 2560x1440@165, 0x0, 1"
        "${monitors.middle}, 2560x1440@165, 2560x0, 1"
        "${monitors.right}, 1920x1080@60, 5120x-133, 1, transform, 3"
      ];

      workspace = [
        "1, monitor:${monitors.left}, layoutopt:orientation:left, default:true"
        "2, monitor:${monitors.left}, layoutopt:orientation:left"
        "3, monitor:${monitors.left}, layoutopt:orientation:left"
        "4, monitor:${monitors.middle}, layoutopt:orientation:left, default:true"
        "5, monitor:${monitors.middle}, layoutopt:orientation:left"
        "6, monitor:${monitors.middle}, layoutopt:orientation:left"
        "7, monitor:${monitors.middle}, layoutopt:orientation:left"
        "8, monitor:${monitors.right}, layoutopt:orientation:top"
        "9, monitor:${monitors.right}, layoutopt:orientation:top"
        "10, monitor:${monitors.right}, layoutopt:orientation:top, default:true"
      ];

      input = {
        natural_scroll = false;
        sensitivity = -3;
        scroll_factor = 0.5;
      };

      exec-once = [
        "sleep 3;hyprctl dispatch workspace 1;hyprctl dispatch workspace 10;hyprctl dispatch workspace 9;hyprctl dispatch workspace 4"
        "uwsm app -- spotify"
        "uwsm app -- vesktop & sleep 10 && uwsm app -- thunderbird"
      ];

      windowrule = [
        "workspace 1 silent, class:(thunderbird), title:(Mozilla Thunderbird)(.*)$ "
      ];

      bind = [
        # Switch workspace
        "$mod, 1, focusmonitor, ${monitors.left}"
        "$mod, 2, focusmonitor, ${monitors.left}"
        "$mod, 3, focusmonitor, ${monitors.left}"
        "$mod, 4, focusmonitor, ${monitors.middle}"
        "$mod, 5, focusmonitor, ${monitors.middle}"
        "$mod, 6, focusmonitor, ${monitors.middle}"
        "$mod, 7, focusmonitor, ${monitors.middle}"
        "$mod, 8, focusmonitor, ${monitors.right}"
        "$mod, 9, focusmonitor, ${monitors.right}"
        "$mod, 0, focusmonitor, ${monitors.right}"

        # Move window
        "$mod SHIFT, 1, movecurrentworkspacetomonitor, ${monitors.left}"
        "$mod SHIFT, 2, movecurrentworkspacetomonitor, ${monitors.left}"
        "$mod SHIFT, 3, movecurrentworkspacetomonitor, ${monitors.left}"
        "$mod SHIFT, 4, movecurrentworkspacetomonitor, ${monitors.middle}"
        "$mod SHIFT, 5, movecurrentworkspacetomonitor, ${monitors.middle}"
        "$mod SHIFT, 6, movecurrentworkspacetomonitor, ${monitors.middle}"
        "$mod SHIFT, 7, movecurrentworkspacetomonitor, ${monitors.middle}"
        "$mod SHIFT, 8, movecurrentworkspacetomonitor, ${monitors.right}"
        "$mod SHIFT, 9, movecurrentworkspacetomonitor, ${monitors.right}"
        "$mod SHIFT, 0, movecurrentworkspacetomonitor, ${monitors.right}"
      ];
    };
  };
}
