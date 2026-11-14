{
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      timeout = 3;
      efi = {
        canTouchEfiVariables = true;
      };
    };

    # zram related
    kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
    };
  };
}
