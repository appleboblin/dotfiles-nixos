{
  programs.kitty = {
    enable = true;
    # themeFile = "Nord";
    font = {
      name = "MesloLGS Nerd Font Mono";
      size = 16;
    };
    # shellIntegration.enableZshIntegration = true;
    settings = {
      # Looks
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = "15.0";
      cursor_shape = "block";
      background_opacity = "0.95";
      # No close window confirmation
      confirm_os_window_close = "0";
      enable_audio_bell = false;
      window_border_width = "1";
      window_margin_width = "1";
      window_padding_width = "1";
      scrollback_lines = 10000;
      wheel_scroll_multiplier = "5.0";
      click_interval = "0.5";
      mouse_hide_wait = "0.0";

      # Tab bar
      tab_bar_edge = "top";
      tab_bar_style = "fade";
      tab_fade = "0 1 1 1";

      shell = "fish";
    };
  };
}
