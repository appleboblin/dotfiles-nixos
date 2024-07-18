{
    config,
    pkgs,
    lib,
    host,
    home,
    ...
}: {  
    # swaylock image
    #programs.swaylock.settings = {
    #    image = "${./framework_wallpaper.png}";
    #};

    # sawyidle time
    services.swayidle = {
        timeouts = [
            {
                timeout = 600;
                command = "${lib.getExe config.programs.swaylock.package} -f";
            }
            {
                timeout = 1200;
                command = "${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms off";
            }
            {
                timeout = 1800;
                command = "${pkgs.systemd}/bin/systemctl suspend";
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
                "DP-2"
                ];
                modules-left = [ "hyprland/workspaces" ];
                modules-center = [ "hyprland/window" ];
                modules-right = [ "pulseaudio" "cpu" "memory" "network" "clock" "custom/powermenu" ];
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
                "DP-1"
                ];
                modules-left = [ "custom/launcher" "hyprland/workspaces" ];
                modules-center = [ "hyprland/window" ];
                modules-right = [ "tray" "clock" ];
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
                    format-alt = "{:%a %d %b %H:%M}";
                    interval = 60;
                };
                "tray" = {
                    spacing = 10;
                };
                "custom/launcher" = {
                    format = " ";
                    on-click = "pkill rofi || ${lib.getExe pkgs.rofi} -show drun";
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
                "HDMI-A-1"
                ];
                modules-left = [ "hyprland/workspaces" ];
                modules-center = [ "hyprland/window" ];
                modules-right = [ "bluetooth" "idle_inhibitor" ];
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
                "workspace 10 silent, webcord"
                "workspace 10 silent, discord"
                "workspace 10 silent, vesktop"
                # "workspace 10 silent, floorp"
            ];

            windowrulev2 = [
                "workspace 9 silent, class(obsidian), title:(Obsidian)(.*)$"
                "workspace 1 silent, class:(thunderbird), title:(Mozilla Thunderbird)(.*)$ "
            ];

            
            bind = [
                # Switch workspace
                "$mod, 1, focusmonitor, DP-2"
                "$mod, 2, focusmonitor, DP-2"
                "$mod, 3, focusmonitor, DP-2"
                "$mod, 4, focusmonitor, DP-1"
                # "$mod, 4, layoutmsg, orientationleft"
                "$mod, 5, focusmonitor, DP-1"
                # "$mod, 5, layoutmsg, orientationleft"
                "$mod, 6, focusmonitor, DP-1"
                # "$mod, 6, layoutmsg, orientationleft"
                "$mod, 7, focusmonitor, DP-1"
                # "$mod, 7, layoutmsg, orientationleft"
                "$mod, 8, focusmonitor, HDMI-A-1"
                # "$mod, 8, layoutmsg, orientationtop"
                "$mod, 9, focusmonitor, HDMI-A-1"
                # "$mod, 9, layoutmsg, orientationtop"
                "$mod, 0, focusmonitor, HDMI-A-1"
                # "$mod, 0, layoutmsg, orientationtop"
                
                # Move window
                "$mod SHIFT, 1, movecurrentworkspacetomonitor, DP-2"
                "$mod SHIFT, 2, movecurrentworkspacetomonitor, DP-2"
                "$mod SHIFT, 3, movecurrentworkspacetomonitor, DP-2"
                "$mod SHIFT, 4, movecurrentworkspacetomonitor, DP-1"
                # "$mod SHIFT, 4, layoutmsg, orientationleft"
                "$mod SHIFT, 5, movecurrentworkspacetomonitor, DP-1"
                # "$mod SHIFT, 5, layoutmsg, orientationleft"
                "$mod SHIFT, 6, movecurrentworkspacetomonitor, DP-1"
                # "$mod SHIFT, 6, layoutmsg, orientationleft"
                "$mod SHIFT, 7, movecurrentworkspacetomonitor, DP-1"
                # "$mod SHIFT, 7, layoutmsg, orientationleft"
                "$mod SHIFT, 8, movecurrentworkspacetomonitor, HDMI-A-1"
                # "$mod SHIFT, 8, layoutmsg, orientationtop"
                "$mod SHIFT, 9, movecurrentworkspacetomonitor, HDMI-A-1"
                # "$mod SHIFT, 9, layoutmsg, orientationtop"
                "$mod SHIFT, 0, movecurrentworkspacetomonitor, HDMI-A-1"
                # "$mod SHIFT, 0, layoutmsg, orientationtop"
            ];
        };
    };
}
