{
  pkgs,
  lib,
  ...
}:
{
  programs.steam = {
    enable = lib.mkDefault true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  hardware = {
    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };
}
