{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./keybinds.nix
    ./windowrule.nix
  ];

  home.packages = with pkgs; [
    xwayland-satellite
  ];

  programs.niri.settings = {
    environment = {
      CLUTTER_BACKEND = "wayland";
      DISPLAY = ":0";
      GDK_BACKEND = "wayland,x11";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      TERM = "xterm-256color";
      TERMINAL = "footclient";
      XMODIFIERS = "@im=fcitx";
    };
    input = {
      keyboard = {
        xkb = {
          layout = "us";
        };
        numlock = true;
      };

      touchpad = {
        tap = true;
        dwt = true; # disable when typing
        natural-scroll = true;
      };

      mouse = {
        natural-scroll = false;
      };

      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "95%";
      };

      warp-mouse-to-focus.enable = true;
      workspace-auto-back-and-forth = true;
      power-key-handling.enable = false;
    };

    screenshot-path = "~/Pictures/Screenshots/screenshot_%Y%m%d_%H%M%S.png";

    spawn-at-startup =
      let
        command = cmd: { command = lib.lists.flatten [ cmd ]; };
      in
      [
        # Each command is a list of strings, which will be joined with spaces
        (command (lib.getExe pkgs.xwayland-satellite))
        (command [
          "fcitx5"
          "-d"
        ])
        (command [
          "foot"
          "--server"
        ])
        (command "hyprpaper")
        (command "pcloud")
        (command "cryptomator")
        (command "swaync")
        (command [
          "wl-paste"
          "--type"
          "text"
          "--watch"
          "cliphist"
          "store"
          "--max-len"
          "50"
        ])
        (command [
          "wl-paste"
          "--type"
          "image"
          "--watch"
          "cliphist"
          "store"
          "--max-len"
          "10"
        ])
      ];

    layout = {
      center-focused-column = "never";
      always-center-single-column = true;

      border = {
        enable = true;
        width = 1;
        active.color = "#f5bde6";
        inactive.color = "#181926";
        urgent.color = "#ed8796";
      };
      focus-ring.enable = false;
      shadow.enable = false;

      background-color = "24273a";
      default-column-display = "tabbed";

      tab-indicator = {
        hide-when-single-tab = true;
        place-within-column = true;
        width = 5;
        gap = 0;
        position = "left";
        length.total-proportion = 1.0;
        active.color = "#8aadf4";
        urgent.color = "#ed8796";
      };

      preset-column-widths = [
        { proportion = 1.0; }
        { proportion = 1.0 / 2.0; }
        { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 4.0; }
      ];

      preset-window-heights = [
        { proportion = 1.0; }
        { proportion = 1.0 / 2.0; }
        { proportion = 1.0 / 3.0; }
      ];

      default-column-width = {
        proportion = 0.5 / 1.0;
      };

      gaps = 0;
      struts = {
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
      };
    };

    cursor = {
      hide-when-typing = true;
      size = 24;
    };

    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;
  };

  xdg.portal = {
    xdgOpenUsePortal = true;
    # https://github.com/YaLTeR/niri/wiki/Important-Software#portals
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
  };
  services.gnome-keyring.enable = true;
}
