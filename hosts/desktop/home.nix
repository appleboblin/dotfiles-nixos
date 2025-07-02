{
  config,
  pkgs,
  lib,
  ...
}:
let
  monitors = import ./monitors.nix;
in
{
  programs.niri.settings = {
    outputs = {
      "DP-1" = {
        scale = 1.0;
        mode = {
          width = 2560;
          height = 1440;
          refresh = 164.998;
        };
        transform = {
          rotation = 0;
          flipped = false;
        };
        position = {
          x = 0;
          y = 0;
        };
      };
      "DP-2" = {
        scale = 1.0;
        mode = {
          width = 2560;
          height = 1440;
          refresh = 164.998;
        };
        transform = {
          rotation = 0;
          flipped = false;
        };
        position = {
          x = 2560;
          y = 0;
        };
      };
      "HDMI-A-1" = {
        scale = 1.0;
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.000;
        };
        transform = {
          rotation = 270;
          flipped = false;
        };
        position = {
          x = 5120;
          y = -133;
        };
      };
    };
  };

  services.hypridle.settings = {
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

  # Waybar settings
  programs.waybar = lib.mkIf config.programs.waybar.enable {
    settings = [
      {
        layer = "top";
        position = "top";
        height = 50;
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;
        spacing = 15;
        output = [
          "${monitors.left}"
        ];
        modules-left = [ "niri/workspaces" ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "pulseaudio"
          "cpu"
          "memory"
          "network"
          "clock"
          "custom/powermenu"
        ];
        "niri/workspaces" = {
          format = "{index}";
          disable-scroll-wraparound = true;
          on-click = "activate";
          sort-by-number = true;
        };
        "niri/window" = {
          max-length = 50;
          format = "{}";
          separate-outputs = true;
        };
        "clock" = {
          format = "{:%a %d %b %H:%M}";
          locale = "en_US.UTF-8";
          tooltip-format = "<big>{:%A %D}</big>\n<tt><small>{calendar}</small></tt>";
          interval = 1;
        };
        "pulseaudio" = {
          format = "󰕾 {volume}%";
          format-muted = "󰝟 ";
          format-source = " {volume}%";
          format-source-muted = "󰝟 ";
          on-click = "${lib.getExe pkgs.pamixer} -t";
          on-click-right = "pavucontrol";
        };
        "tray" = {
          spacing = 10;
        };
        "cpu" = {
          interval = 1;
          format = " {usage}%";
        };
        "memory" = {
          interval = 5;
          format = " {used} GiB";
        };
        "network" = {
          format = "󰖩 Wifi";
          format-wifi = "󰖩 {essid}";
          format-ethernet = "󰈀 {bandwidthTotalBits}";
          tooltip-format = "{ifname} via {gwaddr}/{cidr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "󰖪 Disconnected";
          interval = 5;
        };
        "custom/powermenu" = {
          format = "";
          on-click = "rofi-power-menu";
        };
      }
      {
        layer = "top";
        position = "top";
        height = 50;
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;
        spacing = 10;
        output = [
          "${monitors.middle}"
        ];
        modules-left = [
          "custom/launcher"
          "niri/workspaces"
        ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "tray"
          "clock"
          "custom/notification"
        ];
        "niri/workspaces" = {
          format = "{index}";
          disable-scroll-wraparound = true;
          on-click = "activate";
          sort-by-number = true;
        };
        "niri/window" = {
          max-length = 50;
          format = "{}";
          separate-outputs = true;
        };
        "clock" = {
          format = "{:%H:%M}";
          locale = "en_US.UTF-8";
          format-alt = "{:%a %d %b %H:%M}";
          interval = 60;
        };
        "tray" = {
          spacing = 10;
        };
        "custom/launcher" = {
          format = " ";
          on-click = "pkill rofi || ${lib.getExe pkgs.rofi} -show drun -theme-str 'window {width: 400px;}'";
        };
        "custom/notification" = {
          "tooltip" = false;
          "format" = "{icon} ";
          "format-icons" = {
            "notification" = "<span foreground='red'><sup></sup></span>";
            "none" = "";
            "dnd-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-none" = "";
            "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "inhibited-none" = "";
            "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-inhibited-none" = "";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          "exec" = "swaync-client -swb";
          "on-click" = "swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          "escape" = true;
        };
      }
      {
        layer = "top";
        position = "top";
        height = 50;
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;
        spacing = 15;
        output = [
          "${monitors.right}"
        ];
        modules-left = [ "niri/workspaces" ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "bluetooth"
          "idle_inhibitor"
        ];
        "niri/workspaces" = {
          format = "{index}";
          disable-scroll-wraparound = true;
          on-click = "activate";
          sort-by-number = true;
        };
        "niri/window" = {
          max-length = 50;
          format = "{}";
          separate-outputs = true;
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶 ";
            deactivated = "󰾪 ";
          };
        };
        "bluetooth" = {
          # // "controller": "controller1", // specify the alias of the controller if there are more than 1 on the system
          format-on = "󰂯";
          format-off = "󰂲";
          format-disabled = ""; # an empty format will hide the module
          format-connected = "󰂯 {num_connections}";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "bluetoothctl power on";
          on-click-right = "bluetoothctl power off";
        };
      }
    ];
  };

  # hyprland config
  wayland.windowManager.hyprland = {
    settings = {
      input = {
        natural_scroll = false;
        sensitivity = -3;
        scroll_factor = 0.5;
      };

      exec-once = [

      ];

      windowrule = [
        # "workspace 9 silent, class(obsidian), title:(Obsidian)(.*)$" # stopped working for some reason so using windowrule
        "workspace 1 silent, class:(thunderbird), title:(Mozilla Thunderbird)(.*)$ "
      ];

      bind = [
        # Switch workspace
        "$mod, 1, focusmonitor, ${monitors.left}"
        "$mod, 2, focusmonitor, ${monitors.left}"
        "$mod, 3, focusmonitor, ${monitors.left}"
        "$mod, 4, focusmonitor, ${monitors.middle}"
        # "$mod, 4, layoutmsg, orientationleft"
        "$mod, 5, focusmonitor, ${monitors.middle}"
        # "$mod, 5, layoutmsg, orientationleft"
        "$mod, 6, focusmonitor, ${monitors.middle}"
        # "$mod, 6, layoutmsg, orientationleft"
        "$mod, 7, focusmonitor, ${monitors.middle}"
        # "$mod, 7, layoutmsg, orientationleft"
        "$mod, 8, focusmonitor, ${monitors.right}"
        # "$mod, 8, layoutmsg, orientationtop"
        "$mod, 9, focusmonitor, ${monitors.right}"
        # "$mod, 9, layoutmsg, orientationtop"
        "$mod, 0, focusmonitor, ${monitors.right}"
        # "$mod, 0, layoutmsg, orientationtop"

        # Move window
        "$mod SHIFT, 1, movecurrentworkspacetomonitor, ${monitors.left}"
        "$mod SHIFT, 2, movecurrentworkspacetomonitor, ${monitors.left}"
        "$mod SHIFT, 3, movecurrentworkspacetomonitor, ${monitors.left}"
        "$mod SHIFT, 4, movecurrentworkspacetomonitor, ${monitors.middle}"
        # "$mod SHIFT, 4, layoutmsg, orientationleft"
        "$mod SHIFT, 5, movecurrentworkspacetomonitor, ${monitors.middle}"
        # "$mod SHIFT, 5, layoutmsg, orientationleft"
        "$mod SHIFT, 6, movecurrentworkspacetomonitor, ${monitors.middle}"
        # "$mod SHIFT, 6, layoutmsg, orientationleft"
        "$mod SHIFT, 7, movecurrentworkspacetomonitor, ${monitors.middle}"
        # "$mod SHIFT, 7, layoutmsg, orientationleft"
        "$mod SHIFT, 8, movecurrentworkspacetomonitor, ${monitors.right}"
        # "$mod SHIFT, 8, layoutmsg, orientationtop"
        "$mod SHIFT, 9, movecurrentworkspacetomonitor, ${monitors.right}"
        # "$mod SHIFT, 9, layoutmsg, orientationtop"
        "$mod SHIFT, 0, movecurrentworkspacetomonitor, ${monitors.right}"
        # "$mod SHIFT, 0, layoutmsg, orientationtop"
      ];
    };
  };
}
