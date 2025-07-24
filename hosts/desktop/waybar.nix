{
  pkgs,
  lib,
  ...
}:
let
  monitors = import ./monitors.nix;

  niriWorkspace = {
    format = "{icon}";
    format-icons = {
      "W0" = "1";
      "W1" = "2";
      "W2" = "3";
      "W3" = "4";
      "W4" = "5";
      "W5" = "6";
      "W6" = "7";
      "W7" = "8";
      "W8" = "9";
      "W9" = "10";
      "Wmusic" = "󰝚";
      default = "";
    };
    disable-scroll-wraparound = true;
    on-click = "activate";
  };

  niriWindow = {
    max-length = 50;
    format = "{}";
    separate-outputs = true;
  };
in
{
  # Waybar settings
  programs.waybar = {
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
        "niri/workspaces" = niriWorkspace;
        "niri/window" = niriWindow;
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
          format-wifi = "󰖩 {bandwidthTotalBits}";
          format-ethernet = "󰈀 {bandwidthTotalBits}";
          tooltip-format = "{ifname} via {gwaddr}/{cidr}; {ipaddr}/{cidr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "󰖪 Disconnected";
          format-alt = "󰛳 {essid}";
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
        spacing = 15;
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
        "niri/workspaces" = niriWorkspace;
        "niri/window" = niriWindow;
        "clock" = {
          format = "{:%H:%M}";
          locale = "en_US.UTF-8";
          format-alt = "{:%a %d %b %H:%M}";
          interval = 60;
        };
        "tray" = {
          spacing = 15;
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
        "niri/workspaces" = niriWorkspace;
        "niri/window" = niriWindow;
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
}
