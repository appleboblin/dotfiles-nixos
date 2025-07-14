{
  config,
  pkgs,
  lib,
  ...
}:
let
  transmissionEnabled = config.services.transmission.enable or false;
in
{
  services.transmission = {
    enable = lib.mkDefault false;
    package = pkgs.transmission_4;
    settings = {
      download-dir = "${config.services.transmission.home}/Downloads";
    };
  };

  hm.home.packages = lib.mkIf transmissionEnabled [
    pkgs.transmission_4-gtk
  ];
}
