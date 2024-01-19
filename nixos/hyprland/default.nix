{
    config,
    pkgs,
    lib,
    ...
}: {
    imports = [
        ./hyprland.nix
        ./hyprpaper.nix
        ./bar.nix
        ./dunst.nix
    ];        
}