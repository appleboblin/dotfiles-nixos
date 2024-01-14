{
    config,
    host,
    isLaptop,
    lib,
    pkgs,
    inputs,
    ...
}: {
    users.users.appleboblin = {
        packages = with pkgs; lib.mkIf config.programs.hyprland.enable[
        hyprpaper
        ];
    };

    hm.xdg.configFile."hypr/hyprpaper.conf".text = lib.mkIf config.programs.hyprland.enable ''
        preload = ${../../home-manager/hyprland/WP_Laser_Up-2560x1440_00229.jpg}
    '';
}