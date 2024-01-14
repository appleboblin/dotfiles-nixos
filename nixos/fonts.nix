{
    config,
    pkgs,
    lib,
    ...
}: {
    fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk
            noto-fonts-emoji
            source-han-sans
            source-han-serif
            inter
            (nerdfonts.override {fonts = [ "Meslo" "FiraCode" "JetBrainsMono"]; })
        ];

        fontconfig = {
            defaultFonts = {
                serif = [ "Inter" ];
                sansSerif = [ "Inter" ];
                monospace = [ "JetBrainsMono Nerd Font" ];
            };
        };
    };
}