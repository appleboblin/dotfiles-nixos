{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
  home.packages = with pkgs; [
    ddcutil
  ];
  programs.noctalia = {
    enable = true;

    settings = {
      battery.warning_threshold = 25;

      brightness.enable_ddcutil = true;

      control_center.shortcuts = [
        { type = "bluetooth"; }
        { type = "caffeine"; }
        { type = "nightlight"; }
        { type = "notification"; }
        { type = "power_profile"; }
        { type = "keyboard_layout"; }
      ];

      idle = {
        behavior_order = [
          "lock"
          "screen-off"
          "lock-and-suspend"
        ];
        pre_action_fade_seconds = 0;
      };

      location.auto_locate = true;

      lockscreen = {
        blur_intensity = 0.099999997764825821;
        tint_intensity = 0.0;
      };

      nightlight.enabled = true;

      osd.kinds = {
        media = false;
      };

      shell = {
        avatar_path = "${./jigglypuff.png}";
        font_family = "Inter Nerd Font";
        niri_overview_type_to_launch_enabled = true;
        polkit_agent = true;
        screen_time_enabled = true;
        animation.enabled = false;
        launcher = {
          categories = false;
          compact = true;
          providers = {
            session.global = true;
            windows.global = true;
          };
        };
        panel = {
          open_near_click_control_center = true;
          open_near_click_session = true;
          shadow = false;
        };
        screenshot.directory = "/home/appleboblin/Pictures/Screenshots";
      };

      theme = {
        builtin = "Catppuccin";
        community_palette = "Catppuccin Macchiato Pink";
        mode = "dark";
        source = "community";
        wallpaper_scheme = "m3-content";
        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };

      wallpaper = {
        default.path = "${./WP_Laser_Up-2560x1440_00229.jpg}";
      };

      widget = {
        clock.format = "{:%a %d %b %H:%M}";
        media.hide_when_no_media = true;
        network.show_label = false;
        tray.drawer = true;
        workspaces = {
          active_pill_size = 1.0;
          display = "none";
          hide_when_empty = true;
          max_label_chars = 1;
        };
      };
    };
  };
}
