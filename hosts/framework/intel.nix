# Framework 13, 12th-gen Intel mainboard
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.nixos-hardware.nixosModules.framework-12th-gen-intel ];

  boot.kernelModules = [ "kvm-intel" ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  environment.systemPackages = [ pkgs.intel-gpu-tools ];
}
