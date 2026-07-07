{
  lib,
  ...
}:
let
  monitors = import ./monitors.nix;
in
{
  services = {
    easyeffects.enable = true;
    niri-ws-maximize = {
      enable = true;
      targetWorkspaces = [
        "1"
        "2"
        "3"
        "stuff"
      ];
    };
  };

  programs = {
    # niri config
    niri.settings = {
      spawn-at-startup =
        let
          command = cmd: { command = lib.lists.flatten [ cmd ]; };
        in
        [
          (command "vesktop")
          (command "spotify")
        ];

      workspaces =
        lib.genAttrs [ "1" "2" "3" "stuff" ] (_: {
          open-on-output = monitors.left;
        })
        // lib.genAttrs (map toString (lib.range 4 9)) (_: {
          open-on-output = monitors.middle;
        });

      outputs = {
        "DP-2" = {
          scale = 1.0;
          variable-refresh-rate = true;
          mode = {
            width = 2560;
            height = 1440;
            refresh = 170.002;
          };
          transform = {
            rotation = 90;
            flipped = false;
          };
          position = {
            x = 0;
            y = 0;
          };
        };
        "DP-1" = {
          scale = 1.0;
          mode = {
            width = 2560;
            height = 1440;
            refresh = 179.999;
          };
          transform = {
            rotation = 0;
            flipped = false;
          };
          position = {
            x = 1440;
            y = 550;
          };
        };
      };
    };
  };
}
