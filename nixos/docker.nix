{
    config,
    pkgs,
    lib,
    user,
    ...
}: {
    users.users.${user}.extraGroups = [ "docker" ];

    virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
    };
}
