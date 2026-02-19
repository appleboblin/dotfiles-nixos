{
  user,
  ...
}:
{
  # include if want to auto start docker
  # sudo systemctl start docker
  users.users.${user}.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;

    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
  };
}
