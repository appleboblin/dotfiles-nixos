{
  config,
  pkgs,
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

  pcloud-watch = pkgs.writeShellApplication {
    name = "pcloud-watch";
    runtimeInputs = with pkgs; [
      networkmanager
      coreutils
      gnugrep
      systemd
    ];
    text = ''
      dir="$XDG_RUNTIME_DIR/pcloud-watch"
      mkdir -p "$dir"

      stop() { rm -f "$dir"/*; systemctl --user stop pcloud.service; exit 0; }

      # Seconds since a condition first went bad; resets once it's good again
      elapsed() { # name, is_bad
        local f="$dir/$1" now
        if (( $2 )); then
          now=$(date +%s)
          [[ -f $f ]] || echo "$now" > "$f"
          echo $(( now - $(<"$f") ))
        else
          rm -f "$f"
          echo -1
        fi
      }

      # Immediate stops
      [[ $(nmcli radio wifi) == enabled ]] || stop

      ac=0 bat=100
      for s in /sys/class/power_supply/*; do
        case $(<"$s/type") in
          Mains)   if [[ $(<"$s/online") == 1 ]]; then ac=1; fi ;;
          Battery) bat=$(<"$s/capacity") ;;
        esac
      done
      if (( !ac && bat < 15 )); then stop; fi

      wifi=0
      if grep -qx 'wifi:connected' <<<"$(nmcli -t -f TYPE,STATE device)"; then wifi=1; fi

      # Grace periods
      off=$(elapsed nowifi $(( !wifi )))
      unplugged=$(elapsed noac $(( !ac )))
      if (( off >= 300 || unplugged >= 600 )); then stop; fi

      if (( wifi && ac )); then systemctl --user start pcloud.service; fi
    '';
  };
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
            "lockscreen-widget-0000000000000005"
          ];

          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
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
  };

  services = {
    niri-ws-maximize = {
      enable = true;
      targetWorkspaces = [
        "stuff"
      ];
    };
  };

  systemd.user = {
    services = {
      pcloud = {
        Unit = {
          Description = "pCloud";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.pcloud}/bin/pcloud";
          # clean up the FUSE mount if pcloud gets killed
          ExecStopPost = "-/run/wrappers/bin/fusermount -uz %h/pCloudDrive";
        };
      };
      pcloud-watch = {
        Unit.Description = "Start/stop pCloud based on Wi-Fi and power";
        Service = {
          Type = "oneshot";
          ExecStart = "${pcloud-watch}/bin/pcloud-watch";
        };
      };
    };

    timers.pcloud-watch = {
      Unit.PartOf = [ "graphical-session.target" ];
      Timer = {
        OnActiveSec = "10s";
        OnUnitActiveSec = "2min";
        AccuracySec = "30s";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

}
