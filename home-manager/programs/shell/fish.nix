{
    config,
    pkgs,
    lib,
    ...
}: {
    programs.fish = {
        enable = true;
        interactiveShellInit = ''
            set fish_greeting ""
        '';
        # shellAliases = {
        #     ls = "eza -a --icons";
        #     rebuild = "sudo nixos-rebuild switch --flake .#${host}";
        # };
    };
}