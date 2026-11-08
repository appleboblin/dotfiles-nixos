{
  lib,
  ...
}:
{
  services.tailscale = {
    enable = lib.mkDefault true;
    # chmod file to 600 after creating it.
    # authKeyFile = "/etc/tailscale-authkey";
    useRoutingFeatures = "client";
    openFirewall = true;
    # Applied via `tailscale set` on every tailscaled start (no authKeyFile needed).
    extraSetFlags = [
      "--accept-routes"
      # Keep the local LAN reachable while routing through an exit node.
      "--exit-node-allow-lan-access"
    ];
  };
}
