{ pkgs, ... }:
let
  threshold = 20; # percent
  interval = 1800; # seconds between checks while asleep
  rtcwake = "${pkgs.util-linux}/bin/rtcwake";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  check = pkgs.writeShellScript "lowbat-check" ''
    bat=$(echo /sys/class/power_supply/BAT*)
    lid=$(cat /proc/acpi/button/lid/*/state 2>/dev/null)

    # Lid open = user woke it: normal resume
    if [[ "$lid" != *closed* ]]; then
      ${rtcwake} -m disable
      exit 0
    fi

    if [[ $(cat "$bat/status") == Discharging ]] \
       && (( $(cat "$bat/capacity") < ${toString threshold} )); then
      ${pkgs.systemd}/bin/systemd-run --on-active=2 ${systemctl} poweroff
    else
      # Same pattern as your fprintd unit: don't call suspend from inside suspend.target
      ${pkgs.systemd}/bin/systemd-run --on-active=5 ${systemctl} suspend
    fi
  '';
in
{
  systemd.services = {
    lowbat-arm = {
      description = "Arm RTC wake to check battery during suspend";
      wantedBy = [ "suspend.target" ];
      before = [ "systemd-suspend.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${rtcwake} -m no -s ${toString interval}";
      };
    };
    lowbat-check = {
      description = "Power off if woken with lid closed and low battery";
      wantedBy = [ "suspend.target" ];
      after = [ "systemd-suspend.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = check;
      };
    };
  };
}
