{
  config,
  pkgs,
  ...
}:
{
  services.transmission = {
    enable = true; # optional
    package = pkgs.transmission_4;
    settings = {
      download-dir = "${config.services.transmission.home}/Downloads";
    };

  };
  environment.systemPackages = with pkgs; [ transmission_4-gtk ];
}
