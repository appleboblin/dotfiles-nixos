{
  lib,
  pkgs,
  ...
}:
let
  monitors = import ./monitors.nix;
  loginBox = import ../../home-manager/graphical/noctalia-login-box.nix;
in
{
  services = {
    easyeffects.enable = true;
  };

  programs = {
    noctalia = {
      settings = {
        bar = {
          order = [
            "hor"
            "ver"
          ];
          hor = {
            center = [ "active_window" ];
            enabled = false;
            end = [
              "volume"
              "ram"
              "cpu"
              "network"
              "clock"
              "notifications"
              "control-center"
              "session"
            ];
            margin_edge = 0;
            margin_ends = 0;
            radius = 0;
            shadow = false;
            start = [
              "launcher"
              "workspaces"
            ];
            monitor."DP-1".enabled = true;
          };
          ver = {
            center = [ "active_window" ];
            enabled = false;
            end = [
              "media"
              "tray"
              "caffeine"
              "bluetooth"
              "clock"
            ];
            margin_edge = 0;
            margin_ends = 0;
            radius = 0;
            start = [ "workspaces" ];
            monitor."DP-2".enabled = true;
          };
        };

        battery = {
          device."/org/freedesktop/UPower/devices/keyboard_dev_EA_B8_0D_78_3A_18".warning_threshold = 25;
        };

        idle = {
          behavior_order = [
            "lock"
            "screen-off"
            "lock-and-suspend"
            "lock-and-suspend-media"
          ];
          behavior = {
            lock = {
              timeout = 600;
            };
            "screen-off" = {
              timeout = 900;
            };
            # suspend unless media is playing
            "lock-and-suspend" = {
              timeout = 1800;
              command = "${pkgs.playerctl}/bin/playerctl -a status 2>/dev/null | grep -qx Playing || noctalia msg session lock-and-suspend";
            };
            # suspend
            "lock-and-suspend-media" = {
              enabled = true;
              timeout = 7200;
              command = "noctalia msg session lock-and-suspend";
            };
          };
        };

        lockscreen_widgets = {
          widget_order = [
            "lockscreen-login-box@DP-1"
            "lockscreen-login-box@DP-2"
            "lockscreen-widget-0000000000000001"
            "lockscreen-widget-0000000000000002"
            "lockscreen-widget-0000000000000003"
          ];

          grid = {
            cell_size = 24;
          };

          widget = {
            "lockscreen-login-box@DP-1" = {
              box_height = 196.0;
              box_width = 720.0;
              cx = 1280.0;
              cy = 1056.0;
              output = "DP-1";
              placement_height = 1440.0;
              placement_width = 2560.0;
              rotation = 0.0;
              type = "login_box";
              settings = loginBox;
            };

            "lockscreen-login-box@DP-2" = {
              box_height = 196.0;
              box_width = 720.0;
              cx = 720.0;
              cy = 2192.0;
              output = "DP-2";
              placement_height = 2560.0;
              placement_width = 1440.0;
              rotation = 0.0;
              type = "login_box";
              settings = {
                background_color = "surface_variant";
                background_opacity = 0.88;
                background_radius = 12.0;
                center_password_text = false;
                input_opacity = 1.0;
                input_radius = 6.0;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = true;
                show_session_buttons = true;
                show_unlock_hint = true;
                show_weather = true;
              };
            };

            "lockscreen-widget-0000000000000001" = {
              box_height = 288.0;
              box_width = 576.0;
              cx = 1280.0;
              cy = 480.0;
              output = "DP-1";
              placement_height = 1440.0;
              placement_width = 2560.0;
              rotation = 0.0;
              type = "clock";
              settings = {
                background = false;
                background_color = "surface";
                background_opacity = 0.0;
                background_padding = 0;
                background_radius = 0;
                center_text = true;
                circle = true;
                clock_style = "digital";
                color = "on_surface";
                font_family = "";
                format = "{:%H:%M}";
                shadow = false;
              };
            };

            "lockscreen-widget-0000000000000002" = {
              box_height = 288.0;
              box_width = 696.0;
              cx = 720.0;
              cy = 1280.0;
              output = "DP-2";
              placement_height = 2560.0;
              placement_width = 1440.0;
              rotation = 0.0;
              type = "audio_visualizer";
              settings = {
                background = false;
                bands = 32;
                color_1 = "primary";
                color_2 = "primary";
                show_when_idle = true;
              };
            };

            "lockscreen-widget-0000000000000003" = {
              box_height = 120.0;
              box_width = 384.0;
              cx = 1280.0;
              cy = 636.0;
              output = "DP-1";
              placement_height = 1440.0;
              placement_width = 2560.0;
              rotation = 0.0;
              type = "clock";
              settings = {
                background = false;
                background_color = "surface";
                background_opacity = 0.0;
                background_padding = 0;
                background_radius = 0;
                center_text = true;
                circle = true;
                clock_style = "digital";
                color = "on_surface";
                font_family = "";
                format = "%A %d %B";
                shadow = true;
              };
            };
          };
        };

        system.monitor.gpu_poll_seconds = 5;

        widget = {
          active_window.anchor = true;
        };

        wallpaper.monitors = {
          "DP-1".path = "${../../home-manager/graphical/WP_Laser_Up-2560x1440_00229.jpg}";
          "DP-2".path = "${../../home-manager/graphical/WP_Laser_Up-2560x1440_00229.jpg}";
        };
      };
    };

    umbriel.settings = {
      general.autostart = [
        "vesktop"
        "spotify"
      ];

      output.${monitors.left} = {
        mode = "2560x1440@170";
        transform = "90";
        position = [
          0
          0
        ];
        vrr = "always";
        workspaces = [
          "1"
          "2"
          "3"
          "stuff"
        ];
        layout.scrolling.default_extent_fraction = 1.0;
      };
      output.${monitors.middle} = {
        mode = "2560x1440@180";
        position = [
          1440
          550
        ];
        workspaces = map toString (lib.range 4 9);
      };

      keybinds =
        lib.listToAttrs (
          lib.concatMap (n: [
            (lib.nameValuePair "Mod+${n}" (lib.mkForce "workspace-switch --name ${n}"))
            (lib.nameValuePair "Mod+Shift+${n}" (lib.mkForce "column-move-to-workspace --name ${n}"))
          ]) (map toString (lib.range 1 9))
        )
        // {
        };
    };
  };
}
