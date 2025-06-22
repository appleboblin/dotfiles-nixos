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
    ./bar
    # ./bar/hyprpanel.nix
    ./lock.nix
    ./idle.nix
    ./wlsunset.nix
    ./swaync.nix
  ];

  # home = lib.mkIf wayland.windowManager.hyprland.enable {
  #     XCURSOR_SIZE = "24";
  #     HYPR_LOG = "/tmp/hypr/$(command ls -t /tmp/hypr/ | grep -v lock | head -n 1)/hyprland.log";
  # };

  # shellAliases = lib.mkIf wayland.windowManager.hyprland.enable{
  #     hypr-log = "less /tmp/hypr/$(command ls -t /tmp/hypr/ | grep -v lock | head -n 1)/hyprland.log";
  # };
  # lib.mkIf config.wayland.windowManager.hyprland.enable
  # lib.mkIf osConfig.programs.hyprland.enable
  config = {
    home = {
      packages = with pkgs; [
        # clipboard history
        cliphist
        # (cliphist.overrideAttrs (o: {
        # src = pkgs.fetchFromGitHub {
        # owner = "sentriz";
        # repo = "cliphist";
        # rev = "c49dcd26168f704324d90d23b9381f39c30572bd";
        # sha256 = "sha256-2mn55DeF8Yxq5jwQAjAcvZAwAg+pZ4BkEitP6S2N0HY=";
        # };
        # vendorHash = "sha256-M5n7/QWQ5POWE4hSCMa0+GOVhEDCOILYqkSYIGoy/l0=";
        # }))
        wl-clipboard
        hyprpicker
      ];
    };

    xdg.portal = {
      enable = true;
      # wlr.enable = false;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      configPackages = [
        pkgs.xdg-desktop-portal-hyprland
      ];
    };

    wayland.windowManager.hyprland = {
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
          # kb_variant = "colemak_dh_ortho";
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
          # nord
          # "col.active_border" = "rgba(81a1c1ee) rgba(88c0d0ee) 45deg";
          # "col.inactive_border" = "rgba(3b4252aa)";
          "col.active_border" = "rgba(f5bde6cc) rgba(f5bde6cc) 45deg";
          "col.inactive_border" = "rgba(3b4252aa)";
          layout = "master";
        };

        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
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
          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
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
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = false; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # you probably want this
          smart_split = false;
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_status = "slave";
          orientation = "left";
          new_on_top = false;
        };

        exec-once = [
          # clipboard manager
          "wl-paste --type text --watch cliphist store --max-len 50"
          "wl-paste --type image --watch cliphist store --max-len 10"
          # "ectool raw 0x3E0C d1,d1,b1,b3,wE01F & ectool raw 0x3E0C d1,d1,b3,b1,w11"
          # "nm-applet --indicator"

          # Desktop dependency
          "uwsm app -- foot --server & sleep 5 && uwsm app -- footclient -a scratch"
          # "ghostty --class=com.term.scratch"
          # "uwsm app -- hyprpaper & uwsm app -- waybar & uwsm app -- fcitx5 -d & uwsm app -- swaync"
          "uwsm app -- hyprpaper & uwsm app -- hyprpanel & uwsm app -- fcitx5 -d "
          # "flatpak run dev.vencord.Vesktop; sleep 10; latpak run dev.vencord.Vesktop"
          "uwsm app -- vesktop & uwsm app -- spotify & uwsm app -- obsidian & uwsm app -- pcloud & sleep 5 && uwsm app -- thunderbird"
          # kitty ncspot kitty --class scratchpad
          # "${lib.getExe pkgs.swayidle} -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' timeout 1200 'systemctl suspend'"
          # Default browser fix
          "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
          # "systemctl --user start hyprsunset.service"
        ];
      };
    };
  };
}
