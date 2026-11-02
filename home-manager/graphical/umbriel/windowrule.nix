{
  programs.umbriel.settings.window_rule = [
    {
      match.is_alone = true;
      default_scrolling_extent = 1.0;
    }
    # prevent starting applications from grabbing focus
    {
      match.at_startup = true;
      default_focused = false;
      default_floating = false;
    }
    {
      match.app_id = "OrcaSlicer";
      default_maximize = true;
    }
    {
      match.app_id = "xdg-desktop-portal-gtk";
      default_floating = true;
      default_focused = true;
    }
    {
      match.app_id = [
        "Proton Pass"
        "vesktop"
        "^element-desktop$"
      ];
      block_capture = true;
    }
    {
      match.app_id = [
        "vesktop"
        "^element-desktop$"
        "spotify"
      ];
      default_workspace = "stuff";
      default_maximize = true;
      default_focused = false;
    }
  ];
}
