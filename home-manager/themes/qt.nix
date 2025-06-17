{
  pkgs,
  ...
}:

let
  catppuccinKv = pkgs.catppuccin-kvantum.override {
    variant = "macchiato";
    accent = "pink";
  };
in
{
  home.packages = with pkgs; [
    catppuccinKv
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    qt6ct
    qt6.qtwayland
  ];

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      package = catppuccinKv;
    };
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Catppuccin-Macchiato-Pink
  '';
  xdg.configFile."Kvantum/Catppuccin-Macchiato-Pink".recursive = true;
  xdg.configFile."Kvantum/Catppuccin-Macchiato-Pink".source =
    "${catppuccinKv}/share/Kvantum/Catppuccin-Macchiato-Pink";

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    style=kvantum
  '';
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    style=kvantum
  '';

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_STYLE_OVERRIDE = "kvantum";
  };
}
