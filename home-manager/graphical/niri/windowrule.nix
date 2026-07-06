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
        { app-id = "element"; }
        { app-id = "spotify"; }
      ];
      open-on-workspace = "stuff";
      open-maximized = true;
      open-focused = false;
      open-floating = false;
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
      matches = [ { app-id = "zen-beta"; } ];
      draw-border-with-background = false;
      border = {
        enable = true;
        width = 2;
      };
      focus-ring = {
        enable = true;
        width = 2;
      };
    }
  ];
}
