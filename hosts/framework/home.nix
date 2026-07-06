{
  config,
  ...
}:
let
  mkWorkspace = name: {
    name = name;
    value = {
      open-on-output = "eDP-1";
    };
  };

  workspaceNames = [
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
    "stuff"
  ];
in
{
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

    # niri config
    niri.settings = {
      binds = with config.lib.niri.actions; {
        "XF86AudioMedia".action = spawn "footclient";
      };
      switch-events = {
        lid-close.action.spawn = [
          "noctalia"
          "msg"
          "session"
          "lock-and-suspend"
        ];
      };
      workspaces = builtins.listToAttrs (map mkWorkspace workspaceNames);
      outputs = {
        "eDP-1" = {
          scale = 1.0;
          mode = {
            width = 2256;
            height = 1504;
            refresh = 60.000;
          };
          transform = {
            rotation = 0;
            flipped = false;
          };
          position = {
            x = 0;
            y = 0;
          };
        };
      };
    };
  };
}
