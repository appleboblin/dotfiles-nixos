{
    lib,
    ...
}: {
    services.hypridle = {
        settings = {
            general = {
                lock_cmd = "pidof hyprlock || hyprlock";
                before_sleep_cmd = "loginctl lock-session";
                after_sleep_cmd = "hyprctl dispatch dpms on";
                ignore_dbus_inhibit = false;
            };

            listener = lib.mkDefault [
                {
                timeout = 5 * 60;
                on-timeout = "loginctl lock-session";
                }
                {
                timeout = 10 * 60;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
                }
                {
                timeout = 20 * 60;
                on-timeout = "systemctl suspend";
                }
            ];

        };
    };
}
