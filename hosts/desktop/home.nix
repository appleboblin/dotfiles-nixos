{
  lib,
  inputs,
  ...
}:
let
  monitors = import ./monitors.nix;
in
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  services = {
    easyeffects.enable = true;
    niri-ws-maximize = {
      enable = true;
      targetWorkspaces = [
        "1"
        "2"
        "3"
        "stuff"
      ];
    };
  };

  programs = {
    # niri config
    niri.settings = {
      spawn-at-startup =
        let
          command = cmd: { command = lib.lists.flatten [ cmd ]; };
        in
        [
          (command "vesktop")
          (command "spotify")
        ];

      workspaces =
        lib.genAttrs [ "1" "2" "3" "stuff" ] (_: {
          open-on-output = monitors.left;
        })
        // lib.genAttrs (map toString (lib.range 4 9)) (_: {
          open-on-output = monitors.middle;
        });

      outputs = {
        "DP-2" = {
          scale = 1.0;
          variable-refresh-rate = true;
          mode = {
            width = 2560;
            height = 1440;
            refresh = 170.002;
          };
          transform = {
            rotation = 90;
            flipped = false;
          };
          position = {
            x = 0;
            y = 0;
          };
        };
        "DP-1" = {
          scale = 1.0;
          mode = {
            width = 2560;
            height = 1440;
            refresh = 179.999;
          };
          transform = {
            rotation = 0;
            flipped = false;
          };
          position = {
            x = 1440;
            y = 550;
          };
        };
      };
    };

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
          behavior = {
            lock = {
              action = "lock";
              enabled = true;
              timeout = 600.0;
            };
            "lock-and-suspend" = {
              action = "lock_and_suspend";
              enabled = true;
              timeout = 3600.0;
            };
            "screen-off" = {
              action = "screen_off";
              enabled = true;
              timeout = 900.0;
            };
          };
        };

        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;
          widget_order = [
            "lockscreen-login-box@DP-1"
            "lockscreen-login-box@DP-2"
            "lockscreen-widget-0000000000000001"
            "lockscreen-widget-0000000000000002"
            "lockscreen-widget-0000000000000003"
          ];

          grid = {
            cell_size = 24;
            major_interval = 4;
            visible = true;
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

            "lockscreen-widget-0000000000000004" = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 1376.0;
              cy = 1248.0;
              output = "DP-1";
              rotation = 0.0;
              type = "button";
              settings = {
                background = true;
                command = "noctalia msg session shutdown";
                glyph = "shutdown";
                label = "";
                variant = "default";
              };
            };

            "lockscreen-widget-0000000000000005" = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 1280.0;
              cy = 1248.0;
              output = "DP-1";
              rotation = 0.0;
              type = "button";
              settings = {
                background = true;
                command = "noctalia msg session reboot";
                glyph = "reboot";
                label = "";
                variant = "default";
              };
            };

            "lockscreen-widget-0000000000000006" = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 1188.0;
              cy = 1248.0;
              output = "DP-1";
              rotation = 0.0;
              type = "button";
              settings = {
                background = true;
                command = "noctalia msg session lock-and-suspend";
                glyph = "player-pause-filled";
                label = "";
                variant = "default";
              };
            };
          };
        };

        system.monitor.gpu_poll_seconds = 5;

        widget = {
          active_window.anchor = true;
          clock.format = "{:%a %d %b %H:%M}";
          cpu.show_label = false;
          ram.show_label = false;
        };
      };
    };
  };
}
