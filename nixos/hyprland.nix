{
    config,
    host,
    isLaptop,
    lib,
    pkgs,
    inputs,
    ...
}: {
    programs.hyprland = lib.mkIf ( host != "vm" ) {
        enable = true;
        xwayland.enable = true;
        # portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    hm.wayland.windowManager.hyprland = lib.mkIf config.programs.hyprland.enable {
        enable = true;
    };

    # Hint electron apps to use wayland
    environment.sessionVariables = lib.mkIf config.programs.hyprland.enable {
        NIXOS_OZONE_WL = "1";
        XDG_SESSION_TYPE = "wayland";
        WLR_NO_HARDWARE__CURSORS = "1";
        MOZ_ENABLE_WAYLAND = "1";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOp = "Hyprland";
        GTK_USE_PORTAL = "1";
        NIXOS_XDG_OPEN_USE_PORTAL = "1";
    };

    # Enable bar
    hm.programs.waybar = lib.mkIf config.programs.hyprland.enable {
        enable = true;
    };

    # Enable notification
    hm.services.dunst = lib.mkIf config.programs.hyprland.enable {
        enable = true;
    };

    # Wallpaper
    users.users.appleboblin = {
        packages = with pkgs; lib.mkIf config.programs.hyprland.enable[
        hyprpaper
        ];
    };

    hm.xdg.configFile."hypr/hyprpaper.conf".text = lib.mkIf config.programs.hyprland.enable ''
        preload = ${../home-manager/hyprland/WP_Laser_Up-2560x1440_00229.jpg}
    '';
}