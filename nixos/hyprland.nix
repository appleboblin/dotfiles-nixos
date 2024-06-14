{
    config,
    host,
    isLaptop,
    lib,
    pkgs,
    inputs,
    ...
}: {
    # Override xdg.portal.wlr.enable, theres conflict
	xdg.portal = {
		wlr.enable = lib.mkForce false;
	};
    programs.hyprland = lib.mkIf ( host != "vm" ) {
        enable = true;
        # xwayland.enable = true;
        # portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    # environment.systemPackages = lib.mkIf config.programs.hyprland.enable [ pkgs.xwaylandvideobridge ];

    hm.wayland.windowManager.hyprland = lib.mkIf config.programs.hyprland.enable {
        enable = true;
    };

    # Hint electron apps to use wayland
    # environment.sessionVariables = lib.mkIf config.programs.hyprland.enable {
    #     NIXOS_OZONE_WL = "1";
    #     WLR_NO_HARDWARE_CURSORS = "1";
    #     MOZ_ENABLE_WAYLAND = "1";
    #     SDL_VIDEODRIVER = "wayland";
    #     CLUTTER_BACKEND = "wayland";
    #     XDG_CURRENT_DESKTOP = "Hyprland";
    #     XDG_SESSION_DESKTOP = "Hyprland";
    #     XDG_SESSION_TYPE = "wayland";
    #     GTK_USE_PORTAL = "1";
    #     NIXOS_XDG_OPEN_USE_PORTAL = "1";
    # };

    # Enable bar
    hm.programs.waybar = lib.mkIf config.programs.hyprland.enable {
        enable = true;
    };

    hm.programs.swaylock = lib.mkIf config.programs.hyprland.enable {
        enable = true;
    };

    # locking with swaylock
    security.pam.services.swaylock = lib.mkIf config.programs.hyprland.enable {
        text = "auth include login";
    };

    # Enable auto lock
    hm.services.swayidle = lib.mkIf config.programs.hyprland.enable {
        enable = true;
    };

    # Enable notification
    hm.services.dunst = lib.mkIf config.programs.hyprland.enable {
        enable = true;
    };

    # Wallpaper, brightness
    users.users.appleboblin = {
        packages = with pkgs; lib.mkIf config.programs.hyprland.enable[
        hyprpaper
        # brightnessctl
        playerctl
        ];
    };

    hm.xdg.configFile."hypr/hyprpaper.conf".text = lib.mkIf config.programs.hyprland.enable ''
        preload = ${../home-manager/hyprland/WP_Laser_Up-2560x1440_00229.jpg}
        splash = false
    '';
}