{
    config,
    pkgs,
    lib,
    host,
    ...
}: {
    programs.mpv = {
        enable = host != "vm"; # optional
        scripts = with pkgs; [
            mpvScripts.uosc
        ];
    };
}
