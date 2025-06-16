{
  pkgs,
  ...
}:
{
  boot = {
    loader = {
      timeout = 3;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };

      grub = {
        enable = true;
        # efiInstallAsRemovable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        theme = pkgs.catppuccin-grub.override {
          flavor = "macchiato";
        };
      };
    };
  };
}
