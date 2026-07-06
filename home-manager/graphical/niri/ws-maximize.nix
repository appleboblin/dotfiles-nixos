{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.niri-ws-maximize;

  niri-ws-maximize = pkgs.rustPlatform.buildRustPackage {
    pname = "niri-ws-maximize";
    version = "0.2.0";
    src = ./niri-ws-maximize;
    cargoLock.lockFile = ./niri-ws-maximize/Cargo.lock;
  };
in
{
  options.services.niri-ws-maximize = {
    enable = lib.mkEnableOption "niri solo-window column maximizer";

    targetWorkspaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "1"
        "2"
        "3"
        "stuff"
      ];
      description = ''
        Named workspaces on which every window's column is forced to 100%
        width regardless of window count. Empty list means only the
        solo-window rule applies.
      '';
    };

    restoreWidth = lib.mkOption {
      type = lib.types.str;
      default = "50%";
      description = ''
        Column width restored when a window is no longer solo (or leaves a
        target workspace). Match your default column width preset.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.niri-ws-maximize = {
      Unit = {
        Description = "niri: maximize solo windows; force-maximize on target workspaces";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${niri-ws-maximize}/bin/niri-ws-maximize";
        Environment = [
          "NIRI_BIN=${config.programs.niri.package}/bin/niri"
          "NIRI_RESTORE_WIDTH=${cfg.restoreWidth}"
        ]
        ++ lib.optional (
          cfg.targetWorkspaces != [ ]
        ) "NIRI_WS_TARGETS=${lib.concatStringsSep "," cfg.targetWorkspaces}";
        Restart = "always";
        RestartSec = 1;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
