{
  config,
  host,
  lib,
  pkgs,
  ...
}:
let
  wpPath = ../../home-manager/graphical/WP_Laser_Up-2560x1440_00229.jpg;
in
{
  imports = [
    ./waybar.nix
  ];

  # font size
  gtk.font.size = 21;

  programs = {
    zed-editor = {
      userSettings = {
        terminal = {
          font_size = 21;
        };
        ui_font_size = 20;
        buffer_font_size = 21;
      };
    };

    foot = {
      settings = {
        main = {
          font = "MesloLGS Nerd Font Mono:size=17";
        };
      };
    };

    ghostty = {
      settings = {
        font-size = "17";
      };
    };

    # hyprlock image
    hyprlock.settings.background = {
      path = "${./framework_wallpaper.png}";
    };

    vscode = {
      profiles.default.userSettings = {
        "editor.fontSize" = 15;
        "window.zoomLevel" = 2;
        "terminal.integrated.fontSize" = 14;
        "markdown.preview.fontSize" = 15;
        "workbench.productIconTheme" = "material-product-icons";
        "editor.fontFamily" = "'MesloLGS Nerd Font Mono', 'monospace', monospace";
        "terminal.integrated.defaultProfile.linux" = "fish";
      };
    };
  };

  services.hyprpaper.settings = {
    wallpaper = [
      "eDP-1,${wpPath}"
    ];
  };

  # hyprland config
  wayland.windowManager.hyprland = {
    monitor = [
      "eDP-1, 2256x1504, 0x0, 1"
    ];

    workspace = [
      "1, monitor:eDP-1, default:true"
      "2, monitor:eDP-1"
      "3, monitor:eDP-1"
      "4, monitor:eDP-1"
      "5, monitor:eDP-1"
      "6, monitor:eDP-1"
      "7, monitor:eDP-1"
      "8, monitor:eDP-1"
      "9, monitor:eDP-1"
      "10, monitor:eDP-1"
    ];

    settings = {
      input = {
        natural_scroll = true;
        sensitivity = 0;
      };

      exec-once = [
        # brightness on startup
        "${lib.getExe pkgs.brightnessctl} s 40%"
        "sleep 3;hyprctl dispatch workspace 8;hyprctl dispatch workspace 9;hyprctl dispatch workspace 10;hyprctl dispatch workspace 1"
      ];

      windowrule = [
        "workspace 8 silent, class:(thunderbird), title:(Mozilla Thunderbird)(.*)$ "
      ];
    };
  };
}
