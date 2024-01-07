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
    # programs.wayland = lib.mkIf ( host != "vm" ) {
    #     enable = true;
    # };
    # set here as legacy linux won't be able to set these
    # wayland.windowManager.hyprland = {
    #     enable = true;
    #     package = inputs.hyprland.packages.pkgs.hyprland;
    # };

    # xdg.portal = {
    #     enable = true;
    #     extraPortals = [
    #     pkgs.xdg-desktop-portal-gtk
    #     ];
    # };
}