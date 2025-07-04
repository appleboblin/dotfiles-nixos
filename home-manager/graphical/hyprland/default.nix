{
  pkgs,
  lib,
  isLaptop,
  isVm,
  ...
}:
{
  imports = [
    ./keybinds.nix
    ./windowrule.nix
  ];
  config = {
    home = {
      packages = with pkgs; [
        # clipboard history
        cliphist
        wl-clipboard
      ];
    };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      configPackages = [
        pkgs.xdg-desktop-portal-hyprland
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      settings = {
        env = [
          "XCURSOR_SIZE,24"
          "NIXOS_OZONE_WL,1"
          "WLR_NO_HARDWARE_CURSORS,1"
          "MOZ_ENABLE_WAYLAND,1"
          "SDL_VIDEODRIVER,wayland"
          "CLUTTER_BACKEND,wayland"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "GTK_USE_PORTAL,1"
          "NIXOS_XDG_OPEN_USE_PORTAL,1"
        ];

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          numlock_by_default = true;

          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
            scroll_factor = 0.7;
          };
        };

        device = {
          name = "kensington-slimblade-pro(2.4ghz-receiver)-kensington-slimblade-pro-trackball(2.4ghz-receiver)";
          sensitivity = 0.1;
          accel_profile = "adaptive";
        };

        "$mod" = if isVm then "ALT" else "SUPER";

        gestures = lib.mkIf isLaptop {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = true;
          workspace_swipe_fingers = 4;
        };

        misc = {
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          enable_swallow = false;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        debug = {
          disable_logs = false;
        };

        general = {
          gaps_in = 0;
          gaps_out = 0;
          border_size = 2;
          "col.active_border" = "rgba(f5bde6cc) rgba(f5bde6cc) 45deg";
          "col.inactive_border" = "rgba(3b4252aa)";
          layout = "master";
        };

        decoration = {
          blur = {
            enabled = true;
            size = 5;
            passes = 1;
            new_optimizations = true;
          };
          rounding = 0;
        };

        animations = {
          enabled = true;
          bezier = [
            "myBezier, 0.05, 0.9, 0.1, 1.05"
          ];
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = false;
          preserve_split = true;
          smart_split = false;
        };

        master = {
          new_status = "slave";
          orientation = "left";
          new_on_top = false;
        };

        exec-once = [
          # clipboard manager
          "wl-paste --type text --watch cliphist store --max-len 50"
          "wl-paste --type image --watch cliphist store --max-len 10"

          # Desktop dependency
          "uwsm app -- foot --server & sleep 5 && uwsm app -- footclient -a scratch"
          "uwsm app -- fcitx5 -d & uwsm app -- swaync"
          "uwsm app -- vesktop & uwsm app -- spotify & uwsm app -- obsidian & uwsm app -- pcloud & sleep 5 && uwsm app -- thunderbird"
          # Default browser fix
          "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
        ];
      };
    };
  };
}
