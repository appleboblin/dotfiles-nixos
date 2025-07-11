{
  services.tailscale = {
    enable = true;
    authKeyFile = "/etc/tailscale-authkey.env";
    useRoutingFeatures = "client";
    openFirewall = true;
    extraUpFlags = [
      "--accept-routes"
      "--exit-node-allow-lan-access"
    ];
  };
  # Auto Login with Auth Key, chmod authkey file to 600
  # systemd.services.tailscaled = {
  #   serviceConfig = {
  #     EnvironmentFile = "/etc/tailscale-authkey.env";
  #   };
  #   postStart = ''
  #     if ! /run/current-system/sw/bin/tailscale status >/dev/null 2>&1; then
  #       /run/current-system/sw/bin/tailscale up --authkey=$TAILSCALE_AUTHKEY
  #     fi
  #   '';
  # };
}
