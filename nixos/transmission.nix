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

  hm = lib.mkIf transmissionEnabled {
    home.packages = [ pkgs.transmission_4-gtk ];
    xdg.mimeApps.defaultApplications."x-scheme-handler/magnet" = "transmission-gtk.desktop";
  };
}
