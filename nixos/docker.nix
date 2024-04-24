{
    config,
    host,
    lib,
    pkgs,
    inputs,
    user,
    ...
}: {
    users.users.${user}.extraGroups = [ "docker" ];

    virtualisation.docker = {
        enable = true;
    };
}
