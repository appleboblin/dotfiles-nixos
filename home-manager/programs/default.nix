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
        ./nixvim/default.nix
        ./rofi.nix
        ./pcloud.nix
        ./spicetify.nix
        ./obs-studio.nix
        ./mpv.nix
        ./btop.nix
        ./ncmpcpp.nix
        ./foot.nix
        ./beets.nix
        ./nemo.nix
    ];
}