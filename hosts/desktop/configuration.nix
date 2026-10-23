{
  lib,
  pkgs,
  user,
  ...
}:
{
  boot.zfs.requestEncryptionCredentials = false;

  networking.hostId = "b709075d";

  hardware = {
    graphics = {
      # opencl
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };

    # bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = lib.mkForce true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy.AutoEnable = true;
      };
    };

    # Xone kernel driver for xbox controller
    xone.enable = true;
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  # AMDGPU Controller
  # https://wiki.nixos.org/wiki/AMD_GPU
  # https://github.com/paschoal/dotfiles/blob/master/hardware/radeon/default.nix
  environment = {
    sessionVariables = {
      HIP_VISIBLE_DEVICES = "0";
      ROCR_VISIBLE_DEVICES = "0";
    };
    systemPackages = with pkgs; [
      amdgpu_top
    ];
  };

  # recommended for ROCm systems
  # https://rocm.docs.amd.com/projects/install-on-linux/en/docs-6.0.0/how-to/prerequisites.html
  users.users.${user} = {
    description = "${user}";
    extraGroups = [
      "video"
      "render"
    ];
  };

  services = {
    lact.enable = true;
    # transmission.enable = true;
    hardware.bolt.enable = true;
    # BT wake from suspend: TP-Link BT dongle and VIA hub
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="2357", ATTR{idProduct}=="0604", ATTR{power/wakeup}="enabled"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="2109", ATTR{idProduct}=="2817", ATTR{power/wakeup}="enabled"
    '';
  };

  custom.games.enable = true;

  programs.kdeconnect.enable = true;
}
