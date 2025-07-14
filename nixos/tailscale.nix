{
  lib,
  ...
}:
{
  services.tailscale = {
    enable = lib.mkDefault true;
    # chmod file to 600 after creating it.
    authKeyFile = "/etc/tailscale-authkey";
    useRoutingFeatures = "client";
    openFirewall = true;
    extraUpFlags = [
      "--accept-routes"
    ];
  };
}
