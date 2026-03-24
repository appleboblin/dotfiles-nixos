{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.niri.nixosModules.niri
    ./kanata.nix
  ];

  boot.zfs.requestEncryptionCredentials = true;

  networking.hostId = "3f4e9fd8";

  hardware = {
    bluetooth = {
      enable = true;
      # powerOnBoot = lib.mkForce false;
    };
  };

  # AMDGPU Controller
  # https://wiki.nixos.org/wiki/AMD_GPU
  # https://github.com/paschoal/dotfiles/blob/master/hardware/radeon/default.nix
  environment.systemPackages = with pkgs; [
    lact
    amdgpu_top
    fw-ectool
    framework-tool
  ];

  # Desktop environment
  # Override xdg.portal.wlr.enable, theres conflict
  xdg.portal = {
    wlr.enable = lib.mkForce false;
  };

  programs = {
    niri.enable = true;
    hyprland = {
      enable = false;
      withUWSM = true;
    };
  };

  services = {
    fwupd.enable = true;
    power-profiles-daemon.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    libinput.touchpad.disableWhileTyping = lib.mkForce true;
    blueman.enable = true;
    hardware.bolt.enable = true;

    fprintd = {
      enable = true;
      package = pkgs.fprintd-tod;
      tod.enable = true;
      # Search for "libfprint" in packages to find other drivers
      tod.driver = pkgs.libfprint-2-tod1-goodix;
    };

    logind.settings.Login.HandlePowerKey' = "lock";
  };
}
