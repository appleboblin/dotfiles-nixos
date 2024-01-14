{
    config,
    host,
    isLaptop,
    lib,
    pkgs,
    inputs,
    ...
}: {
    hm.programs.waybar = lib.mkIf config.programs.hyprland.enable {
        enable = true;
    };
}