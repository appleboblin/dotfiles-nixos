{
  boot = {
    loader = {
      systemd-boot.enable = true;
      timeout = 3;
      # efi = {
      #   canTouchEfiVariables = true;
      #   efiSysMountPoint = "/boot";
      # };
    };
  };
}
