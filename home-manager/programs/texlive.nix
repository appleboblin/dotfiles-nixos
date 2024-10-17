{
    config,
    pkgs,
    lib,
    host,
    ...
}: {
    programs.texlive = {
        enable = true;
    };
}
