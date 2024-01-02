{
    pkgs,
    lib,
    ...
}: {
    fonts.packages = witn pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        (nerdfonts.oderride {fonts = [ "MesloLGS" ]; })
    ];
};