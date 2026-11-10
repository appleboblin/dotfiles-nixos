{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    qt6.qtwayland
  ];

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
    };
  };

  # QT_STYLE_OVERRIDE is exported by qt.style.name
  home.sessionVariables.CALIBRE_USE_SYSTEM_THEME = "1";
}
