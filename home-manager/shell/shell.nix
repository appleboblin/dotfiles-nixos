{
  user,
  ...
}:
{
  # Aliases
  home.shellAliases = {
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
    rebuild = "env -C /home/${user}/dotfiles-nixos nix fmt && git -C /home/${user}/dotfiles-nixos add -A && nh os switch /home/${user}/dotfiles-nixos --ask";
    update = "git -C /home/${user}/dotfiles-nixos pull && rebuild";
    delete = "nh clean all";
    garbage = "nh clean all --keep-since 14d --keep 5";
    dots = "cd /home/${user}/dotfiles-nixos";

    # cd
    ".." = "cd ..";
    "..." = "cd ../..";
  };

  programs = {
    bash.enable = true;
    eza.enable = true;
    nix-your-shell.enable = true;
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}
