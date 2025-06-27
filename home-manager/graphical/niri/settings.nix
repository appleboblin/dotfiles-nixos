{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./bindings.nix
    ./rules.nix
  ];
  # options.graphical.niri.enable = lib.mkEnableOption "Niri window manager";
  # programs.niri.enable = true;
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
      keyboard.xkb = {
        layout = "us";
      };
      keyboard.numlock = true;
      focus-follows-mouse.enable = true;
      warp-mouse-to-focus.enable = true;
      workspace-auto-back-and-forth = true;
    };
    screenshot-path = "~/Screenshots/Screenshot-from-%Y-%m-%d-%H-%M-%S.png";

    spawn-at-startup =
      let
        command = cmd: { command = lib.lists.flatten [ cmd ]; };
      in
      [
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
        (command "waybar")
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

    outputs = {
      "DP-1" = {
        scale = 1.0;
        mode = {
          width = 2560;
          height = 1440;
          refresh = 164.998;
        };
        transform = {
          rotation = 0;
          flipped = false;
        };
        position = {
          x = 0;
          y = 0;
        };
      };
      "DP-2" = {
        scale = 1.0;
        mode = {
          width = 2560;
          height = 1440;
          refresh = 164.998;
        };
        transform = {
          rotation = 0;
          flipped = false;
        };
        position = {
          x = 2560;
          y = 0;
        };
      };
      "HDMI-A-1" = {
        scale = 1.0;
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.000;
        };
        transform = {
          rotation = 270;
          flipped = false;
        };
        position = {
          x = 5120;
          y = -133;
        };
      };
    };
    layout = {
      focus-ring.enable = false;
      border = {
        enable = true;
        width = 1;
        active.color = "#f5c2e7";
        inactive.color = "#313244";
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

  # niri-flake.cache.enable = false;

  xdg.portal = {
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
}
