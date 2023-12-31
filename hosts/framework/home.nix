{
    config,
    pkgs,
    lib,
    host,
    ...
}: {
    wayland.windowManager.hyprland.settings = {
        monitor = [
        "eDP-1, 2256x1504, 0x0, 1"
        ];

        workspace = [
            "1, monitor:eDP-1, default:true"
            "2, monitor:eDP-1"
            "3, monitor:eDP-1"
            "4, monitor:eDP-1"
            "5, monitor:eDP-1"
            "6, monitor:eDP-1"
            "7, monitor:eDP-1"
            "8, monitor:eDP-1"
            "9, monitor:eDP-1"
            "10, monitor:eDP-1"
        ];

        exec-once = [
            # brightness on startup
            "${lib.getExe pkgs.brightnessctl} s 25%"
        ];
    };
}