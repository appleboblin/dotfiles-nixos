{
  host,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # inputs.niri.homeModules.niri
    inputs.niri.nixosModules.niri
    # ./settings.nix
  ];
  programs.niri = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
