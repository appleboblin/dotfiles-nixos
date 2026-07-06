{
  programs.niri.settings.window-rules = [
    # {
    #   matches = [ { app-id = ".*"; } ];
    #   clip-to-geometry = true;
    #   geometry-corner-radius = {
    #     top-left = 20.0;
    #     top-right = 20.0;
    #     bottom-left = 20.0;
    #     bottom-right = 20.0;
    #   };
    # }
    # prevent starting applications from grabbing focus
    # {
    #   matches = [
    #     { at-startup = true; }
    #   ];
    #   open-focused = false;
    #   open-floating = false;
    # }
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
      # default-column-display = "tabbed";
    }
    # {
    #   matches = [
    #     { app-id = "spotify"; }
    #   ];
    #   open-on-workspace = "music";
    #   open-maximized = true;
    #   open-focused = false;
    #   open-floating = false;
    #   # default-column-display = "tabbed";
    # }
    {
      matches = [
        { app-id = "Proton Pass"; }
        { app-id = "thunderbird"; }
        { app-id = "vesktop"; }
        { app-id = "Element"; }
      ];
      block-out-from = "screen-capture";
    }
    # {
    #   matches = [
    #     { app-id = "dev.zed.Zed"; }
    #   ];
    #   default-column-width.proportion = 1.0;
    # }
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
  programs.niri.settings.layer-rules = [
    {
      matches = [ { namespace = ".*syawnc.*"; } ];
      block-out-from = "screen-capture";
      opacity = 0.8;
    }
  ];
}
