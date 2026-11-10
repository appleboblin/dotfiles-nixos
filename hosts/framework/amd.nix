# Framework 13, Ryzen 7040 mainboard
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.nixos-hardware.nixosModules.framework-13-7040-amd ];

  boot.kernelModules = [ "kvm-amd" ];

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    # if overclocking or underclock
    # amdgpu.overdrive.enable = true;
    framework.laptop13.audioEnhancement.rawDeviceName = "alsa_output.pci-0000_c1_00.6.analog-stereo";
  };

  # AMDGPU Controller
  # https://wiki.nixos.org/wiki/AMD_GPU
  # https://github.com/paschoal/dotfiles/blob/master/hardware/radeon/default.nix
  environment.systemPackages = [ pkgs.amdgpu_top ];
}
