{
    config,
    pkgs,
    lib,
    ...
}: {
    services.swayidle = lib.mkDefault {
        # enable = true;
        # package = pkgs.swayidle;
        systemdTarget = "hyprland-session.target";
        events = [
            {
                event = "before-sleep";
                command = "${lib.getExe config.programs.swaylock.package} -f";
            }
            {
                event = "after-resume";
                command = "${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms on";
            }
            {
                event = "lock";
                command = "${lib.getExe config.programs.swaylock.package} -f";
            }
        ];
        timeouts = [
            {
                timeout = 300;
                command = "${lib.getExe config.programs.swaylock.package} -f";
            }
            {
                timeout = 600;
                command = "${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms off";
            }
            {
                timeout = 1200;
                command = "${pkgs.systemd}/bin/systemctl suspend";
            }
        ];
    };
}