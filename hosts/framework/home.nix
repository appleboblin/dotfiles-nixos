{
    config,
    pkgs,
    lib,
    host,
    home,
    ...
}: {  
    # swaylock image
    programs.swaylock.settings = {
        image = "${./framework_wallpaper.png}";
    };

    # Waybar settings
    programs.waybar = lib.mkIf config.programs.waybar.enable {
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
                modules-right = [ "tray" "idle_inhibitor" "bluetooth" "pulseaudio" "network" "battery" "clock" ];

                "wlr/workspaces" = {
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
                };
                "battery" = {
                    states = {
                        good = 95;
                        warning =  30;
                        critical = 15;
                    };
                    interval = 5;
                    format = "{capacity}% {icon}";
                    format-charging = "{capacity}% 󰂄";
                    format-plugged = "{capacity}%  ";
                    format-alt = "{time} {icon}";
                    format-icons = ["󰁺" "󰁼" "󰁿" "󰂁" "󰁹"];
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
            }
        ];
    };

    # hyprland config
    wayland.windowManager.hyprland = {
        settings = {
            exec-once = [
                # switch alt and mod
                # "ectool raw 0x3E0C d1,d1,b1,b3,wE01F & ectool raw 0x3E0C d1,d1,b3,b1,w11"
                # "nm-applet --indicator & disown"
            ];

            windowrule = [
                "workspace 9 silent, vesktop"
                # "workspace 10 silent, floorp"
            ];

            windowrulev2 = [
                "workspace 8 silent, class(obsidian), title:(Obsidian)(.*)$"
                "workspace 10 silent, class:(thunderbird), title:(Mozilla Thunderbird)(.*)$ "
            ];
        };
    };
}
