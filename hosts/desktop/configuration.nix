{
  host,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  networking.hostName = host;
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "b709075d";
  services.zfs.autoScrub.enable = true;
  nix.settings.download-buffer-size = 524288000;
  zramSwap.enable = true;
  hardware = {
    graphics = {
      enable = true;
      # opencl
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
      # vulkan
      enable32Bit = true;
    };

    # bluetooth
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = lib.mkForce true; # powers up the default Bluetooth controller on boot
    };

    # Xone kernel driver for xbox controller
    xone.enable = true;
  };

  # AMDGPU Controller
  # https://wiki.nixos.org/wiki/AMD_GPU
  # https://github.com/paschoal/dotfiles/blob/master/hardware/radeon/default.nix
  environment.systemPackages = with pkgs; [
    lact
    amdgpu_top
  ];

  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  services = {
    transmission.enable = true;
    blueman.enable = true;
    hardware.bolt.enable = true;
  };

  # Desktop environment
  xdg.portal = {
    wlr.enable = lib.mkForce false;
  };

  programs = {
    steam.enable = true;
    niri.enable = true;

    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };

}
