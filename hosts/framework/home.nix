{
  config,
  ...
}:
let
  loginBox = import ../../home-manager/graphical/noctalia-login-box.nix;

  workspaceNames = [
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
    "stuff"
  ];
in
{
  imports = [ ./pcloud.nix ];

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

    noctalia = {
      settings = {
        bar.default = {
          start = [
            "launcher"
            "workspaces"
          ];
          center = [ "active_window" ];
          end = [
            "media"
            "tray"
            "network"
            "bluetooth"
            "volume"
            "battery"
            "clock"
            "notifications"
            "control-center"
            "session"
          ];
          margin_edge = 0;
          margin_ends = 0;
          radius = 0;
          shadow = false;
        };
        idle = {
          behavior = {
            lock = {
              timeout = 300.0;
            };
            "lock-and-suspend" = {
              action = "lock_and_suspend";
              timeout = 900.0;
            };
            "screen-off" = {
              timeout = 600.0;
            };
          };
        };
        lockscreen = {
          wallpaper = "${./framework_wallpaper.png}";
        };
        lockscreen_widgets = {
          widget_order = [
            "lockscreen-login-box@eDP-1"
            "lockscreen-widget-0000000000000001"
            "lockscreen-widget-0000000000000005"
          ];

          grid = {
            cell_size = 16;
          };

          widget = {
            "lockscreen-login-box@eDP-1" = {
              box_height = 196.0;
              box_width = 720.0;
              cx = 1128.0;
              cy = 1165.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "login_box";
              settings = loginBox;
            };

            "lockscreen-widget-0000000000000001" = {
              box_height = 256.0;
              box_width = 640.0;
              cx = 1128.0;
              cy = 432.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "clock";
              settings = {
                background = false;
                center_text = true;
                clock_style = "digital";
                format = "{:%H:%M}";
                shadow = false;
              };
            };

            "lockscreen-widget-0000000000000005" = {
              box_height = 48.0;
              box_width = 368.0;
              cx = 1128.0;
              cy = 592.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "clock";
              settings = {
                background = false;
                center_text = true;
                clock_style = "digital";
                format = "%A %d %B";
                shadow = false;
              };
            };
          };
        };
      };
    };

    umbriel.settings = {
      output."eDP-1" = {
        mode = "2256x1504@60";
        scale = 1.0;
        workspaces = workspaceNames;
      };

      events.lid_close = "noctalia msg session lock-and-suspend";

      keybinds."XF86AudioMedia" = "spawn footclient";
    };

  };
}
