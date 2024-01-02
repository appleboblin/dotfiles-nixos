{
    config,
    pkgs,
    lib,
    ...
}: {
    imports = [
        ./plasma.nix
        ./fonts.nix
        ./transmission.nix
    ];
}