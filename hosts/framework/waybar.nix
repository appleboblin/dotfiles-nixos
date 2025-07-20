{
  pkgs,
  lib,
  ...
}:
{
  # Waybar settings
  programs.waybar = {
    settings = [
      {
        layer = "top";
        position = "top";
        height = 20;
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;
        spacing = 10;
        output = [
          "eDP-1"
        ];
        modules-left = [ "niri/workspaces" ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "tray"
          "custom/wireguard"
          "idle_inhibitor"
          # "bluetooth"
          "pulseaudio"
          "network"
          "power-profiles-daemon"
          "battery"
          "clock"
          "custom/notification"
        ];

        "niri/workspaces" = {
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
        "niri/window" = {
          max-length = 50;
          format = "{}";
          separate-outputs = true;
        };
        "clock" = {
          format = "{:%H:%M}";
          locale = "en_US.UTF-8";
          # format-alt = "{:%a %d %b %H:%M}";
          tooltip-format = "<big>{:%A %D}</big>\n<tt><small>{calendar}</small></tt>";
          interval = 60;
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
        "power-profiles-daemon" = {
          format = "{icon}";
          "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
          "tooltip" = true;
          "format-icons" = {
            "default" = " ";
            "performance" = " ";
            "balanced" = " ";
            "power-saver" = " ";
          };
        };
        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          interval = 5;
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}%  ";
          format-alt = "{time} {icon}";
          format-icons = [
            "󰁺"
            "󰁼"
            "󰁿"
            "󰂁"
            "󰁹"
          ];
        };
        "network" = {
          #  "interface": "wlp2*", // (Optional) To force the use of this interface
          format = "󰖩 Wifi";
          # format-wifi = "󰖩 {essid}";
          format-wifi = "󰖩 {bandwidthTotalBits}";
          format-ethernet = "󰈀 {bandwidthTotalBits}";
          tooltip-format = "{ifname} via {gwaddr}/{cidr}; {ipaddr}/{cidr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "󰖪 Disconnected";
          format-alt = "󰛳 {essid}";
          interval = 5;
          # on-click = "pkill rofi || rofi-wifi-menu";
          on-click-right = "${lib.getExe pkgs.kitty} nmtui";
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
        "custom/wireguard" = {
          # nm-connection-editor to open up gui editor
          format = "{}";
          format-disconnected = "󰖪 Disconnected";
          exec = "/home/appleboblin/dotfiles-nixos/home-manager/programs/vpn-wg.sh";
          on-click = "rofi -modi 'WireGuard:/home/appleboblin/dotfiles-nixos/home-manager/programs/rofi-wireguard-menu.sh' -show WireGuard";
          interval = 1;
          return-type = "json";
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
    ];
  };
}
