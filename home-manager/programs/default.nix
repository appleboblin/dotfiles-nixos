{
    config,
    pkgs,
    lib,
    ...
}: {
    imports = [
        ./firefox.nix
        ./vscodium.nix
    ];
}