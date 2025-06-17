{
  inputs,
  ...
}:
{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
    hyprland.enable = true;
    overwrite.enable = true;

    settings = {

      menus.clock = {
        time = {
          military = true;
          hideSeconds = false;
        };
        weather = {
          enabled = false;
          unit = "metric";
        };
      };

      menus.dashboard.directories.enabled = true;
      # menus.dashboard.stats.enable_gpu = true;

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
          hypridle = {
            showIcon = true;
            offLabel = "";
            onLabel = "";
          };
          netstat.dynamicIcon = false;
          network = {
            label = true;
            showWifiInfo = true;
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
                "volume"
                "cpu"
                "ram"
                "network"
                "netstat"
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
