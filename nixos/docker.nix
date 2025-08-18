{
  user,
  ...
}:
{
  users.users.${user}.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;

    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
