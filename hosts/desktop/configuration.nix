{
  lib,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./kanata.nix
  ];

  boot.zfs.requestEncryptionCredentials = false;

  networking.hostId = "b709075d";

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

  # AMDGPU Controller
  # https://wiki.nixos.org/wiki/AMD_GPU
  # https://github.com/paschoal/dotfiles/blob/master/hardware/radeon/default.nix
  environment = {
    sessionVariables = {
      HIP_VISIBLE_DEVICES = "0";
      ROCR_VISIBLE_DEVICES = "0";
    };
    systemPackages = with pkgs; [
      # lact
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
    transmission.enable = false;
    hardware.bolt.enable = true;
  };

  # Desktop environment
  xdg.portal = {
    wlr.enable = lib.mkForce false;
  };

  custom.games.enable = true;

  programs = {
    kdeconnect.enable = true;
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };

}
