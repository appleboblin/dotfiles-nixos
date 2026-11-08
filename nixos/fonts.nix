{
  pkgs,
  ...
}:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      source-han-sans
      source-han-serif
      inter
      corefonts
      vista-fonts
      inter-nerdfont
      nerd-fonts.meslo-lg
    ];

    fontconfig.defaultFonts = {
      serif = [
        "Noto Serif"
        "Source Han Serif"
      ];
      sansSerif = [
        "Inter Nerd Font"
        "Source Han Sans"
      ];
      monospace = [ "MesloLGS Nerd Font Mono" ];
    };
  };
}
