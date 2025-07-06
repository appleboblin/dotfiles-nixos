{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.transmission = {
    enable = lib.mkDefault true; # optional
    package = pkgs.transmission_4;
    settings = {
      download-dir = "${config.services.transmission.home}/Downloads";
    };

  };
  environment.systemPackages = with pkgs; [ transmission_4-gtk ];
}
