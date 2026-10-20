# Remember the Bluetooth adapter's power state across reboots, however it was
# toggled (Noctalia, bluetoothctl, ...). Saved at shutdown, restored at boot.
{ pkgs, ... }:
let
  bt = pkgs.writeShellApplication {
    name = "bt-power-state";
    runtimeInputs = with pkgs; [
      bluez
      gnugrep
      coreutils
    ];
    text = ''
      state="$STATE_DIRECTORY/bt-powered-state"

      case "$1" in
        save)
          # capture first: grep -q exiting early would SIGPIPE bluetoothctl under pipefail
          info=$(bluetoothctl show 2>/dev/null || true)
          if grep -q 'Powered: yes' <<<"$info"; then
            echo on > "$state"
          else
            echo off > "$state"
          fi
          ;;
        restore)
          [ "$(cat "$state" 2>/dev/null)" = off ] || exit 0
          # wait for bluetoothd to register the adapter
          for _ in $(seq 20); do
            bluetoothctl show >/dev/null 2>&1 && break
            sleep 0.5
          done
          bluetoothctl power off
          ;;
      esac
    '';
  };
in
{
  systemd.services.bluetooth-power = {
    description = "Save Bluetooth power state at shutdown, restore it at boot";
    after = [ "bluetooth.service" ];
    wants = [ "bluetooth.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      StateDirectory = "bluetooth-power";
      ExecStart = "${bt}/bin/bt-power-state restore";
      # Runs at shutdown, before bluetooth.service stops (ordering is reversed on stop)
      ExecStop = "${bt}/bin/bt-power-state save";
    };
  };
}
