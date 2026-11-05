{ pkgs, ... }:
let
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
