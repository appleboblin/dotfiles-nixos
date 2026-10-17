{
  programs.niri.settings.window-rules = [
    # prevent starting applications from grabbing focus
    {
      matches = [
        { at-startup = true; }
      ];
      open-focused = false;
      open-floating = false;
    }
    {
      matches = [
        { app-id = "vesktop"; }
        { app-id = "^element-desktop$"; }
        { app-id = "spotify"; }
      ];
      open-on-workspace = "stuff";
      open-maximized = true;
      open-focused = false;
      open-floating = false;
    }
    {
      matches = [
        { app-id = "OrcaSlicer"; }
      ];
      open-maximized = true;
    }
    {
      matches = [
        { app-id = "xdg-desktop-portal-gtk"; }
      ];
      open-floating = true;
      open-focused = true;
    }
    {
      matches = [
        { app-id = "Proton Pass"; }
        { app-id = "vesktop"; }
        { app-id = "^element-desktop$"; }
      ];
      block-out-from = "screen-capture";
    }
  ];
}
