# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  host,
  lib,
  pkgs,
  ...
}:
let
  monitors = import ./monitors.nix;
in
{
  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = host;
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
    # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Set lightdm wallpaper
    # services.xserver.displayManager.lightdm.greeters.gtk.extraConfig = ''
    #   font-name = Inter 16
    #   background=${./framework_wallpaper.png}
    # '';

    # bluetooth
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = lib.mkForce true; # powers up the default Bluetooth controller on boot
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    # users.users.appleboblin = {
    #   packages = with pkgs; [
    #   ];
    # };

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

  services.blueman.enable = true;
  services.hardware.bolt.enable = true;

  hm = {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    # environment.systemPackages = with pkgs; [
    #   #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # ];

    xdg.configFile."hypr/hyprpaper.conf".text = lib.mkIf config.programs.hyprland.enable ''
      		wallpaper = ${monitors.left},${../../home-manager/hyprland/WP_Laser_Up-2560x1440_00229.jpg}
          wallpaper = ${monitors.middle},${../../home-manager/hyprland/WP_Laser_Up-2560x1440_00229.jpg}
      		wallpaper = ${monitors.right},${../../home-manager/hyprland/WP_Laser_Up-2560x1440_00229.jpg}
      	'';

    # Hyprland settings
    wayland.windowManager.hyprland.settings = lib.mkIf config.programs.hyprland.enable {
      monitor = [
        "${monitors.left}, 2560x1440@165, 0x0, 1"
        "${monitors.middle}, 2560x1440@165, 2560x0, 1"
        "${monitors.right}, 1920x1080@60, 5120x-133, 1, transform, 3"
      ];

      workspace = [
        "1, monitor:${monitors.left}, layoutopt:orientation:left, default:true"
        "2, monitor:${monitors.left}, layoutopt:orientation:left"
        "3, monitor:${monitors.left}, layoutopt:orientation:left"
        "4, monitor:${monitors.middle}, layoutopt:orientation:left, default:true"
        "5, monitor:${monitors.middle}, layoutopt:orientation:left"
        "6, monitor:${monitors.middle}, layoutopt:orientation:left"
        "7, monitor:${monitors.middle}, layoutopt:orientation:left"
        "8, monitor:${monitors.right}, layoutopt:orientation:top"
        "9, monitor:${monitors.right}, layoutopt:orientation:top"
        "10, monitor:${monitors.right}, layoutopt:orientation:top, default:true"
      ];

      exec-once = [
        "sleep 3;hyprctl dispatch workspace 1;hyprctl dispatch workspace 10;hyprctl dispatch workspace 9;hyprctl dispatch workspace 4"
      ];
    };
  };
}
