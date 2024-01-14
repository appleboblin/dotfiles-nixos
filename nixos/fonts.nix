{
    config,
    pkgs,
    lib,
    ...
}: {
    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        source-han-sans
        source-han-serif
        jetbrains-mono
        (nerdfonts.override {fonts = [ "Meslo" "FiraCode"]; })
    ];
}