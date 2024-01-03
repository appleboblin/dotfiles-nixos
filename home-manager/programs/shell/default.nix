{
    config,
    pkgs,
    lib,
    ...
}: {
    imports = [
        ./starship.nix
        ./fish.nix
        ./shell.nix
    ];
}