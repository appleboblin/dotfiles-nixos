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
    polkit_gnome
    powertop
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

  # sudo powertop --auto-tune
  powerManagement.powertop.enable = true;

  services = {
    fwupd.enable = true;
    power-profiles-daemon.enable = true;

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

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    services.restart-fprintd-after-resume = {
      description = "Restart fprintd after resume";
      wantedBy = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
      after = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemd-run --on-active=2 ${pkgs.systemd}/bin/systemctl restart fprintd.service";
      };
    };
  };

  security = {
    pam = {
      services = {
        login.fprintAuth = false;
        gdm.fprintAuth = false;
        sudo.fprintAuth = false;
        hyprlock = {
          fprintAuth = true;
          unixAuth = true;
        };
      };
    };
  };
}
