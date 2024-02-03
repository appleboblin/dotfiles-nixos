{
    config,
    pkgs,
    lib,
    ...
}: {
    imports = [
        ./firefox.nix
        ./vscodium.nix
        ./kitty.nix
        ./gtk.nix
        ./dunst.nix
        ./nixvim.nix
        ./rofi.nix
        ./pcloud.nix
        ./spicetify.nix
    ];
}