{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    qt6.qtwayland
  ];

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
    };
  };

  xdg.configFile = {
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      style=kvantum
    '';
    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      style=kvantum
    '';
  };

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
    CALIBRE_USE_SYSTEM_THEME = "1";
  };
}
