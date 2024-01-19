{
    config,
    host,
    isLaptop,
    lib,
    pkgs,
    inputs,
    ...
}: {
    hm.services.dunst = lib.mkIf config.programs.hyprland.enable {
        enable = true;
    };
}