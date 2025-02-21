{
    host,
    user,
    ...
}: {
    # Aliases
    home.shellAliases = {
        # Eza
        # ls = "eza --icons";
        # la = "eza -a --icons";
        # ll = "eza -lah --icons";
        # t = "eza --tree";

        # Color grep
        grep = "grep --color=auto";
        egrep = "egrep --color=auto";
        fgrep = "fgrep --color=auto";

        # Program shortcuts
        v = "nvim";
        m = "micro";
        mkdir = "mkdir -p";
        c = "clear";

        # grayjay
        gray = "cd /home/appleboblin/grayjay && nix-shell";

        #NixOS
        rebuild = "git add .; sudo nixos-rebuild switch --flake .#${host}";
        delete = "sudo nix-collect-garbage -d";
        garbage = "sudo nix-collect-garbage --delete-older-than 7d";
        update = "nix flake update";
        dots = "cd /home/${user}/dotfiles-nixos";

        # cd
        ".." = "cd ..";
        "..." = "cd ../..";
    };

    programs.eza = {
        enable = true;
        enableBashIntegration = true;
    };
}
