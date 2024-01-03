{
    config,
    pkgs,
    lib,
    host,
    ...
}: {
    # Aliases
    home.shellAliases = {
        # Eza
        ls = "eza --icons";
        la = "eza -a --icons";
        ll = "eza -lah --icons";
        t = "eza --tree";

        # Color grep
        grep = "grep --color=auto";
        egrep = "egrep --color=auto";
        fgrep = "fgrep --color=auto";

        # Program shortcuts
        v = "nvim";
        m = "micro";
        mkdir = "mkdir -p";
        c = "clear";

        #NixOS
        rebuild = "sudo nixos-rebuild switch --flake .#${host}";

        # cd
        ".." = "cd ..";
        "..." = "cd ../..";

    };
}
