{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; lib.mkForce [
    vscodium
    kitty
  ];
}
