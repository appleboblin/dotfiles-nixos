{
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (osConfig.custom.games.enable or false) {
    home.packages = with pkgs; [
      r2modman
      prismlauncher
    ];
  };
}
