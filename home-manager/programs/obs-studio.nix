{
    pkgs,
    host,
    ...
}: {
    programs.obs-studio = {
        enable = host != "vm";

        plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        # obs-backgroundremoval
        obs-pipewire-audio-capture
        ];
    };
}
