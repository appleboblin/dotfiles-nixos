{
    config,
    pkgs,
    lib,
    ...
}: {
    services.swayidle = {
        
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
                timeout = 600;
                command = "${lib.getExe config.programs.swaylock.package} -f";
            }
            {
                timeout = 1200;
                command = "${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms off";
            }
        ];
    };
}