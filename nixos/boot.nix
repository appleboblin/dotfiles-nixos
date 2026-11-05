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
  };
}
