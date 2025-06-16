{
  config,
  pkgs,
  lib,
  ...
}:
{
  # font size
  gtk.font.size = 21;
  programs = {
    zed-editor = {
      userSettings = {
        terminal = {
          font_size = 21;
        };
        ui_font_size = 20;
        buffer_font_size = 21;
      };
    };

    foot = {
      settings = {
        main = {
          font = "MesloLGS Nerd Font Mono:size=17";
        };
      };
    };

    ghostty = {
      settings = {
        font-size = "17";
      };
    };

    # swaylock image
    # programs.swaylock.settings = {
    #     image = "${./framework_wallpaper.png}";
    # };

    # hyprlock image
    hyprlock.settings.background = {
      path = "${./framework_wallpaper.png}";
    };

    # Waybar settings
    waybar = lib.mkIf config.programs.waybar.enable {
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
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "tray"
            "custom/wireguard"
            "idle_inhibitor"
            "bluetooth"
            "pulseaudio"
            "network"
            "battery"
            "clock"
            "custom/notification"
          ];

          "hyprland/workspaces" = {
            format = "{name}";
            disable-scroll-wraparound = true;
            on-click = "activate";
            sort-by-number = true;
          };
          "hyprland/window" = {
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
            # format = "{icon} {volume}% {format_source}";
            format = "󰕾 {volume}%";
            # format-bluetooth = "{icon} {volume}% {format_source}";
            # format-bluetooth-muted = "󰝟 {icon} {format_source}";
            format-muted = "󰝟 ";
            format-source = " {volume}%";
            format-source-muted = "󰝟 ";
            # format-icons = {
            #     headphone = "";
            #     hands-free = "󱠡";
            #     headset = "󰋎";
            #     phone = "";
            #     portable = "";
            #     car = "";
            #     default = ["" "" ""];
            # };
            on-click = "${lib.getExe pkgs.pamixer} -t";
            on-click-right = "pavucontrol";
          };
          "tray" = {
            spacing = 10;
            show-passive-items = false;
            reverse-direction = true;
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
            format-wifi = "󰖩 {essid}";
            format-ethernet = "󰈀 {bandwidthTotalBits}";
            tooltip-format = "{ifname} via {gwaddr}/{cidr}";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "󰖪 Disconnected";
            # format-alt = "{ifname}: {ipaddr}/{cidr}";
            interval = 5;
            on-click = "pkill rofi || rofi-wifi-menu";
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

    vscode = {
      profiles.default.userSettings = {
        "editor.fontSize" = 15;
        "window.zoomLevel" = 2;
        "terminal.integrated.fontSize" = 14;
        "markdown.preview.fontSize" = 15;
        #"workbench.colorTheme" = "Nord";
        "workbench.productIconTheme" = "material-product-icons";
        "editor.fontFamily" = "'MesloLGS Nerd Font Mono', 'monospace', monospace";
        "terminal.integrated.defaultProfile.linux" = "fish";
      };
    };
  };

  # hyprland config
  wayland.windowManager.hyprland = {
    settings = {
      input = {
        natural_scroll = true;
        sensitivity = 0;
      };

      exec-once = [
      ];

      windowrule = [
        # "workspace 9 silent, class(obsidian), title:(Obsidian)(.*)$" # stopped working for some reason so using windowrule
        "workspace 8 silent, class:(thunderbird), title:(Mozilla Thunderbird)(.*)$ "
      ];
    };
  };
}
