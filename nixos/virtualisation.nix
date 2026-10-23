{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.virtualisation;
in
{
  config = lib.mkMerge [
    {
      virtualisation = {
        libvirtd.enable = lib.mkDefault false;
        docker.enable = lib.mkDefault false;
      };
    }

    (lib.mkIf cfg.libvirtd.enable {
      virtualisation.spiceUSBRedirection.enable = true;
      programs.virt-manager.enable = true;
      users.users.${user}.extraGroups = [ "libvirtd" ];

      environment.systemPackages = with pkgs; [
        virtiofsd
        spice-gtk
      ];

      networking.firewall = {
        allowedTCPPorts = [ 16509 ]; # libvirt
        allowedTCPPortRanges = [
          {
            from = 5900;
            to = 5999;
          } # SPICE
        ];
      };

      # virt-manager: connect to the system libvirt by default
      hm.dconf.settings."org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    })

    (lib.mkIf cfg.docker.enable {
      users.users.${user}.extraGroups = [ "docker" ];
    })
  ];
}
