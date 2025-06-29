{
  config,
  inputs,
  lib,
  pkgs,
  isLaptop,
  ...
}:

let
  cfg = config.graphical;
  hyprlandEnabled = cfg.hyprland.enable or false;
  niriEnabled = cfg.niri.enable or false;

  compositorEnabled = hyprlandEnabled || niriEnabled;
in
{
  imports = [
    # inputs.hyprpanel.homeManagerModules.hyprpanel
    inputs.niri.nixosModules.niri
  ];
  options.graphical = {
    hyprland.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Hyprland Wayland compositor.";
    };
    niri.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Niri Wayland compositor.";
    };
    swaylock.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable swaylock for screen locking.";
    };
    hyprlock.enable = lib.mkOption {
      type = lib.types.bool;
      default = (compositorEnabled && !(cfg.swaylock.enable or false));
      description = "Enable hyprlock for screen locking.";
    };
    swayidle.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable swayidle for idle management.";
    };
    hypridle.enable = lib.mkOption {
      type = lib.types.bool;
      default = (compositorEnabled && !(cfg.swayidle.enable or false));
      description = "Enable hypridle for idle management.";
    };
    hyprpaper.enable = lib.mkOption {
      type = lib.types.bool;
      default = compositorEnabled;
      description = "Enable HyprPaper for wallpapers.";
    };
    hyprpanel.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable HyprPanel as bar.";
    };
    waybar.enable = lib.mkOption {
      type = lib.types.bool;
      default = (compositorEnabled && !cfg.hyprpanel.enable);
      description = "Enable Waybar as bar.";
    };
    dunst.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Dunst notification daemon.";
    };
    swaync.enable = lib.mkOption {
      type = lib.types.bool;
      default = (compositorEnabled && !cfg.dunst.enable);
      description = "Enable SwayNC notification center.";
    };
    wlsunset.enable = lib.mkOption {
      type = lib.types.bool;
      default = compositorEnabled;
      description = "Enable WLSunset for screen color temperature adjustment.";
    };
    swayosd.enable = lib.mkOption {
      type = lib.types.bool;
      default = niriEnabled;
      description = "Enable SwayOSD for on-screen display notifications.";
    };
  };

  config = {
    assertions = [
      {
        assertion = !(hyprlandEnabled && niriEnabled);
        message = "Can only enable either Hyprland or Niri, not both.";
      }
      {
        assertion =
          !(
            (hyprlandEnabled || niriEnabled)
            && ((cfg.swaylock.enable && cfg.hyprlock.enable) || (!cfg.swaylock.enable && !cfg.hyprlock.enable))
          );
        message = "Enable either swaylock or hyprlock.";
      }
      {
        assertion =
          !(
            (hyprlandEnabled || niriEnabled)
            && ((cfg.hyprpanel.enable && cfg.waybar.enable) || (!cfg.hyprpanel.enable && !cfg.waybar.enable))
          );
        message = "Enable either hyprpanel or waybar.";
      }
    ];

    programs = {
      # Window Manager
      hyprland.enable = hyprlandEnabled;
      niri.enable = niriEnabled;
    };

    services = {
      power-profiles-daemon.enable = lib.mkIf ((hyprlandEnabled || niriEnabled) && isLaptop) true;
      playerctld.enable = lib.mkIf (hyprlandEnabled || niriEnabled) true;
    };

    # Allow swaylock and hyprlock to be used for screen locking
    security.pam.services = {
      swaylock = lib.mkIf cfg.swaylock.enable {
        text = "auth include login";
      };
      hyprlock = lib.mkIf cfg.hyprlock.enable {
        text = "auth include login";
      };
    };

    hm = {
      wayland.windowManager.hyprland = lib.mkIf hyprlandEnabled {
        enable = true;
      };

      programs = {
        # Lock screen
        swaylock.enable = cfg.swaylock.enable;
        hyprlock.enable = cfg.hyprlock.enable;

        # Bar
        waybar.enable = cfg.waybar.enable;
        # hyprpanel.enable = cfg.hyprpanel.enable;
      };

      services = {
        # background
        hyprpaper = lib.mkIf cfg.hyprpaper.enable {
          enable = true;
          settings = {
            splash = false;
            preload = [
              "${../home-manager/graphical/WP_Laser_Up-2560x1440_00229.jpg}"
            ];
          };
        };
        # Idle
        hypridle.enable = cfg.hypridle.enable;
        swayidle.enable = cfg.swayidle.enable;

        # Notification
        dunst.enable = cfg.dunst.enable;
        swaync.enable = cfg.swaync.enable;

        # Other
        wlsunset.enable = cfg.wlsunset.enable;
      };
    };
  };

}
