{
  pkgs,
  lib,
  inputs,
  user,
  ...
}:
{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

  programs.hyprpanel = {
    enable = false;
    systemd.enable = true;
    hyprland.enable = true;
    overwrite.enable = true;

    settings = {
      menus = {
        clock = {
          time = {
            military = true;
            hideSeconds = false;
          };
          weather = {
            enabled = true;
            location = "Kaohsiung, Taiwan";
            unit = "metric";
            # random API key on github
            key = "18314f574825468496c183537250502";
          };
        };
        dashboard = {
          directories = {
            enabled = false;
          };
          stats = {
            enable_gpu = false;
            enabled = true;
          };
          powermenu = {
            shutdown = "systemctl poweroff";
            reboot = "systemctl reboot";
            logout = "hyprctl dispatch exit";
            sleep = "systemctl suspend";

            avatar = {
              image = "${./pfp.ico}";
              name = "${user}";
            };
          };
          shortcuts = {
            enabled = true;
            left = {
              shortcut1 = {
                icon = "";
                tooltip = "Browser";
                command = "uwsm app -- ${lib.getExe pkgs.vivaldi}";
              };
              shortcut2 = {
                icon = "";
                tooltip = "Spotify";
                command = "hyprctl dispatch togglespecialworkspace music";
              };
              shortcut3 = {
                icon = "";
                tooltip = "Vesktop";
                command = "hyprctl dispatch workspace 10";
              };
              shortcut4 = {
                icon = "";
                tooltip = "Rofi";
                command = "uwsm app -- ${lib.getExe pkgs.rofi-wayland} -show drun -run-command 'uwsm app -- {cmd}' -theme-str 'window {width: 400px;}'";
              };
            };
            right = {
              shortcut1 = {
                icon = "";
                tooltip = "Color Picker";
                command = "sleep 0.5 && hyprpicker -a";
              };
              shortcut3 = {
                icon = "";
                tooltip = "nm-editor";
                command = "uwsm app -- nm-connection-editor";
              };
              # shortcut2 = {
              #   icon = "󰄀";
              #   tooltip = "Screenshot";
              #   command = "uwsm app -- grimblast --notify copysave area ~/Pictures/Screenshots/screenshot_$(date '+%Y%m%d_%H%M%S').png";
              # };
              # shortcut4 = {
              #   icon = "";
              #   tooltip = "Files";
              #   command = "uwsm app -- thunar";
              # };
            };
          };
        };
        media = {
          displayTime = true;
        };
      };

      layout = {
        bar = {
          launcher.autoDetectIcon = true;
          workspaces = {
            show_icons = false;
            monitorSpecific = true;
            show_numbered = true;
            workspaces = "1";
            ignored = "-\\d+";
          };
          clock = {
            showIcon = false;
            format = "%a %d %b %H:%M";
          };
          bluetooth.label = false;
          media.show_active_only = true;
          network = {
            label = true;
            showWifiInfo = true;
          };
          volume = {
            scrollUp = "${lib.getExe pkgs.pamixer} -i 5";
            scrollDown = "${lib.getExe pkgs.pamixer} -d 5";
          };
          windowtitle = {
            title_map = [
              [
                "dev.zed.zed"
                ""
                "Zed"
              ]
              [
                "calibre-gui"
                ""
                "Calibre"
              ]
            ];
          };
          customModules = {
            hypridle = {
              showIcon = true;
              label = false;
            };
            netstat = {
              # icon = "";
              lable = true;
              dynamicIcon = true;
              round = true;
              pollingInterval = 1000;
              rateUnit = "MiB"; # "GiB", "MiB", "KiB", "auto"
              leftClick = "menu:network";
            };
            ram = {
              labelType = "percentage"; # "used/total", "percentage", "used", "free"
            };
          };

          systray = {
            enabled = true;
            ignore = [
              "blueman"
              "nm-applet"
              "spotify-client"
              "chrome_status_icon_1"
            ];
          };

          layouts = {
            "DP-1" = {
              left = [
                "workspaces"
              ];
              middle = [
                "windowtitle"
              ];
              right = [
                "netstat"
                "volume"
                "cpu"
                "ram"
                # "network"
                # "netstat"
                "clock"
                "power"
              ];
            };
            "DP-2" = {
              left = [
                "dashboard"
                "workspaces"
                "windowtitle"

              ];
              middle = [
                "media"
              ];
              right = [
                "systray"
                "notifications"
              ];
            };
            "HDMI-A-1" = {
              left = [
                "workspaces"
                "windowtitle"
              ];
              middle = [ "media" ];
              right = [
                "bluetooth"
                "hypridle"
              ];
            };
            "eDP-1" = {
              left = [
                "dashboard"
                "workspaces"
                "windowtitle"
              ];
              middle = [ "media" ];
              right = [
                "tray"
                "hypridle"
                "volume"
                "network"
                "clock"
                "battery"
                "notifications"
              ];
            };
          };
        };
      };

      theme = {
        bar = {
          transparent = true;
          outer_spacing = "0";
          buttons.style = "wave";
        };

        name = "catppuccin_macchiato";

        font = {
          name = "Inter Nerd Font Regular";
          size = "16px";
        };
      };
    };
  };
}
