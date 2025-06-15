{
  lib,
  ...
}:
{
  programs.hyprlock = {
    # Adapted from iynaix's config
    settings = {
      general = {
        disable_loading_bar = false;
        grace = 0;
        hide_cursor = false;
      };

      background = {
        monitor = "";
        path = lib.mkDefault "${./WP_Laser_Up-2560x1440_00229.jpg}";
        blur_passes = 0;
        noise = 0.0117;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      input-field = {
        monitor = "";
        size = "300, 50";
        outline_thickness = 3;
        dots_size = 0.33;
        dots_spacing = 0.15;
        dots_center = true;
        outer_color = "rgb(245, 189, 230)";
        inner_color = "rgba(36, 39, 58, 0.7)";
        font_color = "rgb(202, 211, 245)";
        fade_on_empty = false;
        placeholder_text = "";
        hide_input = false;

        position = "0, -20";
        halign = "center";
        valign = "center";
      };

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<b><big>$(date +"%H:%M")</big></b>"'';
          color = "rgb(202, 211, 245)";
          font_size = 150;
          font_family = "Inter Regular";

          # shadow makes it more readable on light backgrounds
          shadow_passes = 1;
          shadow_size = 4;

          position = "0, 190";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<b><big>$(date +"%A, %-d %B")</big></b>"'';
          color = "rgb(202, 211, 245)";
          font_size = 40;
          font_family = "Inter Regular";

          # shadow makes it more readable on light backgrounds
          shadow_passes = 1;
          shadow_size = 2;

          position = "0, 60";
          halign = "center";
          valign = "center";
        }
      ];
    };

  };

  wayland.windowManager.hyprland.settings = {
    bind = [ "$mod_SHIFT, x, exec, loginctl lock-session" ];
  };

}
