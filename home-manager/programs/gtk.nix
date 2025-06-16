{
  config,
  pkgs,
  lib,
  ...
}:
{
  dconf.settings = {
    # disable dconf first use warning
    "ca/desrt/dconf-editor" = {
      show-warning = false;
    };
    # set dark theme for gtk 4
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  fonts.fontconfig.enable = true;
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-macchiato-pink-compact";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        variant = "macchiato";
        tweaks = [
          # "black" # black tweak for oled
          # "rimless"
        ];
        size = "compact";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        accent = "pink";
        flavor = "macchiato";
      };
    };
    font = {
      name = "Inter Regular";
      package = pkgs.inter;
      size = lib.mkDefault 16;
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
  home = {
    pointerCursor = {
      # package = pkgs.nordzy-cursor-theme;
      # name = "Nordzy-cursor";
      size = 28;
      gtk.enable = true;
      x11.enable = true;
    };

    sessionVariables = {
      XCURSOR_SIZE = config.home.pointerCursor.size;
    };
  };
}
