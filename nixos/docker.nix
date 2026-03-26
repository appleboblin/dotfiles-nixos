{
  config,
  lib,
  user,
  ...
}:
{
  # include if want to auto start docker
  # sudo systemctl start docker
  users.users.${user}.extraGroups = lib.optionals config.virtualisation.docker.enable [ "docker" ];

  virtualisation.docker = {
    enable = lib.mkDefault false;

    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
  };
}
