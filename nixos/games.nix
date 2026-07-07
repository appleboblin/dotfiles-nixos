{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.custom.games;
in
{
  options.custom.games.enable = lib.mkEnableOption "gaming (Steam + userspace tools)";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      remotePlay.openFirewall = true; # Steam Remote Play
      localNetworkGameTransfers.openFirewall = true; # Local Network Game Transfers
    };
  };
}
