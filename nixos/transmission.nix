{
    config,
    pkgs,
    lib,
    ...
}: {
    services.transmission = {
        enable = true; # optional
        package = pkgs.transmission_4;
    };
}