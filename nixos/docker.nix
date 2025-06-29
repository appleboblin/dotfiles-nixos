{
  user,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.custom = {
    distrobox.enable = mkEnableOption "distrobox";
    docker.enable = mkEnableOption "docker" // {
      default = config.custom.distrobox.enable;
    };
  };
  users.users.${user}.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;
  };
}
