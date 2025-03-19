{
  config,
  pkgs,
  lib,
  host,
  ...
}:
{
  programs.xxx = {
    enable = true / host != "vm"; # optional

    settings = {

    };
  };
}
