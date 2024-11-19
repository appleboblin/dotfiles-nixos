{
    pkgs,
    ...
}: {
    # Single timer that triggers every hour
    systemd.user.timers."hyprsunset" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
        OnCalendar = "hourly";
        Unit = "hyprsunset.service";
        Persistent = true;
    };
    };

    # adjust screen temperature based on time
    systemd.user.services."hyprsunset" = {
        description = "Hyprsunset color setter";
        enable = true;
        path = with pkgs; [ coreutils procps hyprsunset ];
        script = ''
            # Get the current hour
            current_hour=$(date +%H)

            # Set temperature based on time ranges
            if [ "$current_hour" -ge 6 ] && [ "$current_hour" -lt 18 ]; then
            temperature=6000
            elif [ "$current_hour" -ge 18 ] && [ "$current_hour" -lt 22 ]; then
            temperature=4000
            else
            temperature=2500
            fi

            # Check if hyprsunset is already running
            if pgrep -x hyprsunset > /dev/null; then
            # Kill the existing instance
            pkill -f -o hyprsunset
            fi

            # Apply the temperature
            hyprsunset -t $temperature
        '';
        serviceConfig = {
            Type = "oneshot";
        };
    };

}
