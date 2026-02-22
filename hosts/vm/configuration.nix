# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  host,
  pkgs,
  user,
  ...
}:
{
  boot.loader = {
    # Bootloader.
    grub.enable = true;
    grub.device = "/dev/vda";
    grub.useOSProber = true;
  };

  networking.hostName = host; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable the Desktop Environment.
  # services.xserver.displayManager.sddm.enable = lib.mkForce false;
  # services.xserver.displayManager.gdm.enable = true;
  # # services.xserver.desktopManager.gnome.enable = true;
  # # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.desktopManager.cinnamon.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    # packages = with pkgs; [
    #   # firefox
    # ];
  };
  services = {
    # Enable auto login
    xserver.displayManager.autoLogin.enable = true;
    xserver.displayManager.autoLogin.user = "${user}";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    thunar
    thunar-volman
    thunar-archive-plugin
  ];
}
