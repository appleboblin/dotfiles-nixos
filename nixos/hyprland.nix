{
  config,
  host,
  lib,
  pkgs,
  ...
}:
{
  # Override xdg.portal.wlr.enable, theres conflict
  xdg.portal = {
    wlr.enable = lib.mkForce false;
  };
  programs.hyprland = lib.mkIf (host != "vm") {
    enable = true;
    withUWSM = true;
    # xwayland.enable = true;
    # portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  # enable power-profiles-daemon
  services.power-profiles-daemon.enable = lib.mkIf (
    config.programs.hyprland.enable && host == "framework"
  ) true;
  hm = {
    # environment.systemPackages = lib.mkIf config.programs.hyprland.enable [ pkgs.xwaylandvideobridge ];
    # Enable hyprland
    wayland.windowManager.hyprland = lib.mkIf config.programs.hyprland.enable {
      enable = true;
    };
    programs = {
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

      # Enable waybar
      waybar = lib.mkIf config.programs.hyprland.enable {
        enable = false;
      };

      # hm.programs.swaylock = lib.mkIf config.programs.hyprland.enable {
      #     enable = true;
      # };

      # # locking with swaylock
      # security.pam.services.swaylock = lib.mkIf config.programs.hyprland.enable {
      #     text = "auth include login";
      # };

      # # Enable auto lock
      # hm.services.swayidle = lib.mkIf config.programs.hyprland.enable {
      #     enable = true;
      # };

      # locking with hyprlock
      hyprlock = lib.mkIf config.programs.hyprland.enable {
        enable = true;
      };
    };
    services = {
      # Enable auto lock
      hypridle = lib.mkIf config.programs.hyprland.enable {
        enable = true;
      };

      # Enable notification
      # Just notification
      dunst = lib.mkIf config.programs.hyprland.enable {
        enable = false;
      };
      # Notification center
      swaync = lib.mkIf config.programs.hyprland.enable {
        enable = false;
      };

      # Enable wlsunset
      wlsunset = lib.mkIf config.programs.hyprland.enable {
        enable = true;
      };
    };

    xdg.configFile."hypr/hyprpaper.conf".text = lib.mkIf config.programs.hyprland.enable ''
      preload = ${../home-manager/hyprland/WP_Laser_Up-2560x1440_00229.jpg}
      splash = false
    '';
  };

  security.pam.services.hyprlock = lib.mkIf config.programs.hyprland.enable {
    text = "auth include login";
  };

  # Wallpaper, brightness
  users.users.appleboblin = {
    packages =
      with pkgs;
      lib.mkIf config.programs.hyprland.enable [
        hyprpaper
        # brightnessctl
        playerctl
      ];
  };
}
