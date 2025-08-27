{
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  swapDevices = [ { device = "/dev/disk/by-label/SWAP"; } ];

  fileSystems = {
    "/" = {
      device = "NIXROOT/root";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    "/home" = {
      device = "NIXROOT/home";
      fsType = "zfs";
    };
  };
}
