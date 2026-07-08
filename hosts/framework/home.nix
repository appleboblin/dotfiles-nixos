{
  config,
  ...
}:
let
  mkWorkspace = name: {
    name = name;
    value = {
      open-on-output = "eDP-1";
    };
  };

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

    vscode = {
      profiles.default.userSettings = {
        "editor.fontSize" = 15;
        "window.zoomLevel" = 2;
        "terminal.integrated.fontSize" = 14;
        "markdown.preview.fontSize" = 15;
        "workbench.productIconTheme" = "material-product-icons";
        "editor.fontFamily" = "'MesloLGS Nerd Font Mono', 'monospace', monospace";
        "terminal.integrated.defaultProfile.linux" = "fish";
      };
    };

    niri.settings = {
      binds = with config.lib.niri.actions; {
        "XF86AudioMedia".action = spawn "footclient";
      };
      switch-events = {
        lid-close.action.spawn = [
          "noctalia"
          "msg"
          "session"
          "lock-and-suspend"
        ];
      };
      workspaces = builtins.listToAttrs (map mkWorkspace workspaceNames);
      outputs = {
        "eDP-1" = {
          scale = 1.0;
          mode = {
            width = 2256;
            height = 1504;
            refresh = 60.000;
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
              action = "lock";
              enabled = true;
              timeout = 300.0;
            };
            "lock-and-suspend" = {
              action = "lock_and_suspend";
              enabled = true;
              timeout = 900.0;
            };
            "screen-off" = {
              action = "screen_off";
              enabled = true;
              timeout = 600.0;
            };
          };
        };
        lockscreen = {
          wallpaper = "${./framework_wallpaper.png}";
        };
        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;
          widget_order = [
            "lockscreen-login-box@eDP-1"
            "lockscreen-widget-0000000000000001"
            "lockscreen-widget-0000000000000002"
            "lockscreen-widget-0000000000000003"
            "lockscreen-widget-0000000000000004"
            "lockscreen-widget-0000000000000005"
          ];

          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };

          widget = {
            "lockscreen-login-box@eDP-1" = {
              type = "login_box";
              output = "eDP-1";
              box_height = 70.0;
              box_width = 400.0;
              cx = 1128.0;
              cy = 1165.0;
              rotation = 0.0;
              settings = {
                background_color = "surface_variant";
                background_opacity = 0.88;
                background_radius = 12.0;
                input_opacity = 1.0;
                input_radius = 6.0;
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_password_hint = true;
              };
            };

            "lockscreen-widget-0000000000000001" = {
              type = "clock";
              output = "eDP-1";
              box_height = 256.0;
              box_width = 640.0;
              cx = 1128.0;
              cy = 432.0;
              rotation = 0.0;
              settings = {
                background = false;
                clock_style = "digital";
                center_text = true;
                format = "{:%H:%M}";
                shadow = false;
              };
            };

            "lockscreen-widget-0000000000000002" = {
              type = "button";
              output = "eDP-1";
              box_height = 0.0;
              box_width = 0.0;
              cx = 1192.0;
              cy = 1296.0;
              rotation = 0.0;
              settings = {
                background = true;
                command = "noctalia msg session shutdown";
                glyph = "shutdown";
                variant = "default";
              };
            };

            "lockscreen-widget-0000000000000003" = {
              type = "button";
              output = "eDP-1";
              box_height = 0.0;
              box_width = 0.0;
              cx = 1128.0;
              cy = 1296.0;
              rotation = 0.0;
              settings = {
                background = true;
                command = "noctalia msg session reboot";
                glyph = "reboot";
                variant = "default";
              };
            };

            "lockscreen-widget-0000000000000004" = {
              type = "button";
              output = "eDP-1";
              box_height = 0.0;
              box_width = 0.0;
              cx = 1064.0;
              cy = 1296.0;
              rotation = 0.0;
              settings = {
                background = true;
                command = "noctalia msg session lock-and-suspend";
                glyph = "player-pause-filled";
                variant = "default";
              };
            };

            "lockscreen-widget-0000000000000005" = {
              type = "clock";
              output = "eDP-1";
              box_height = 48.0;
              box_width = 368.0;
              cx = 1128.0;
              cy = 592.0;
              rotation = 0.0;
              settings = {
                background = false;
                clock_style = "digital";
                center_text = true;
                format = "%A %d %B";
                shadow = false;
              };
            };
          };
        };
      };
    };
  };

  services = {
    niri-ws-maximize = {
      enable = true;
      targetWorkspaces = [
        "stuff"
      ];
    };
  };
}
