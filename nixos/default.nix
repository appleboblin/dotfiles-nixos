{
    config,
    pkgs,
    lib,
    ...
}: {
    imports = [
        ./configuration.nix
        ./plasma.nix
        ./fonts.nix
        ./transmission.nix
        ./hyprland.nix
    ];
}