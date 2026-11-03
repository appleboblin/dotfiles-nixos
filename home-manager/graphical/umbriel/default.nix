{
  inputs,
  ...
}:
{
  imports = [
    inputs.umbriel.homeModules.default
    ./keybinds.nix
    ./windowrule.nix
  ];

  programs.umbriel = {
    enable = true;
    settings = {
      general = {
        autostart = [
          "fcitx5 -d"
          "noctalia"
          "cryptomator"
        ];
        show_cheatsheet = false;
      };

      input = {
        keyboard = {
          layout = "us";
          numlock_toggle = true;
        };
        touchpad = {
          tap = true;
          natural_scroll = true;
          disable_while_typing = true;
        };
        mouse.natural_scroll = false;
        focus.follows_mouse = true;
        cursor = {
          size = 28;
          theme = "catppuccin-macchiato-pink-cursors";
        };
      };

      appearance = {
        border_width = 1;
        corner_radius = 0;
        shadow.enabled = false;
        tab_bar = {
          style = "indicator";
          position = "left";
          height = 5;
          hide_when_single = true;
        };
      };
      animation = {
        duration_ms = 150;
        windows_in.curve = "spring:1,2000";
        windows_out.curve = "spring:1,3000";
        windows_move.curve = "spring:1,1800";
        windows_resize.curve = "spring:1,2000";
        workspaces.curve = "spring:1,1800";
        overview = {
          curve = "spring:1,1800";
          workspace_curve = "spring:1,2200";
        };
        border.curve = "spring:1,2000";
      };
      colors.border = {
        focused = "#f5bde6ff";
        unfocused = "#181926ff";
      };

      layout = {
        gap = 0;
        extent_presets = [
          0.25
          0.333
          0.5
          1.0
        ];
        scrolling = {
          center_underfull_strip = true;
          default_extent_fraction = 0.5;
        };
      };

      workspaces.back_and_forth = true;
    };
  };
}
