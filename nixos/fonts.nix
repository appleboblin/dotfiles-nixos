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
        (nerdfonts.override {fonts = [ "Meslo" ]; })
    ];
}