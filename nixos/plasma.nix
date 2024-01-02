{
    config,
    pkgs,
    lib,
    ...
}: {
    config = {
        environment.plasma5.excludePackages = with pkgs.libsForQt5; [
            khelpcenter
            konsole
            oxygen
        ];

        # qt = {
        #     enable = true;
        #     platformTheme = "qt5ct";
        #     style = "adwaita-dark";
        # };
        # gtk = {
        #     enable = true;
        #     theme = {
        #         name = "Adwaita-dark";
        #         package = pkgs.gnome.gnome-themes-extra;
        #     };
        # };
        # programs.dconf.enable = true;
    };
}