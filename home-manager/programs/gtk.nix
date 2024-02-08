{
    config,
    pkgs,
    lib,
    ...
}: {
    dconf.settings = {
        # disable dconf first use warning
        "ca/desrt/dconf-editor" = {show-warning = false;};
        # set dark theme for gtk 4
        "org/gnome/desktop/interface" = {color-scheme = "prefer-dark";};
    };
    gtk = {
        enable = true;
        theme = {
            name = "Nordic";
            package = pkgs.nordic;
        };
        iconTheme = {
            name = "Nordic-darker";
            package = pkgs.nordic;
        };
        font = {
            name = "Inter";
            package = pkgs.inter;
            size = 16;
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
}