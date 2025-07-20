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
        { app-id = "Element"; }
      ];
      open-on-workspace = "W9";
      open-maximized = true;
      open-focused = true;
      open-floating = false;
      default-column-display = "tabbed";
    }
    {
      matches = [
        { app-id = "spotify"; }
      ];
      open-on-workspace = "Wmusic";
      open-maximized = true;
      open-focused = false;
      open-floating = false;
      default-column-display = "tabbed";
    }
    {
      matches = [
        { app-id = "Proton Pass"; }
        { app-id = "thunderbird"; }
        { app-id = "vesktop"; }
        { app-id = "Element"; }
      ];
      block-out-from = "screen-capture";
    }
    {
      matches = [
        { app-id = "dev.zed.Zed"; }
      ];
      default-column-width.proportion = 1.0;
    }
  ];
  programs.niri.settings.layer-rules = [
    {
      matches = [ { namespace = ".*syawnc.*"; } ];
      block-out-from = "screen-capture";
      opacity = 0.8;
    }
  ];
}
