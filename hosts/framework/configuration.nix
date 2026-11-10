# Shared by every Framework 13 board. Board-specific bits: amd.nix / intel.nix (picked in flake.nix).
{
  lib,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./bluetooth-power.nix
    ./kanata.nix
    ./low-battery-shutdown.nix
  ];

  boot.zfs.requestEncryptionCredentials = true;

  networking.hostId = "3f4e9fd8";

  hardware = {
    bluetooth = {
      enable = true;
      # powerOnBoot = lib.mkForce false;
    };
    # rawDeviceName is set per board by the nixos-hardware module
    framework.laptop13.audioEnhancement.enable = true;
  };

  # virtualisation.libvirtd.enable = true;
  # virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    fw-ectool
    framework-tool
    powertop
  ];

  custom.games.enable = false;

  # sudo powertop --auto-tune
  powerManagement.powertop.enable = true;

  services = {
    fwupd.enable = true;

    libinput.enable = true;
    libinput.touchpad.disableWhileTyping = lib.mkForce true;
    hardware.bolt.enable = true;

    fprintd.enable = true;

    logind.settings.Login = {
      HandlePowerKey = "lock";
      # Lid close: logind suspends (works at the greeter too); Noctalia locks
      # first via lockscreen.lock_before_suspend (default true).
    };
  };

  systemd = {
    services = {
      restart-fprintd-after-resume = {
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

      pcloud-presleep = {
        description = "Stop pCloud before sleep";
        wantedBy = [ "sleep.target" ];
        before = [ "sleep.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.systemd}/bin/systemctl --user -M ${user}@ stop pcloud.service";
        };
      };
    };

  };

  security = {
    pam = {
      services = {
        login.fprintAuth = false;
        greetd.fprintAuth = false;
        sudo.fprintAuth = false;
      };
    };
  };
}
