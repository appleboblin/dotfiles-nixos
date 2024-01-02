{
    config,
    pkgs,
    lib,
    hosts,
    ...
}: {
    # home.packages = with pkgs; [
    #     oh-my-zsh
    # ];

    programs.zsh = {
        enable = true;

        initExtra = ''
            [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
        '';

        enableAutosuggestions = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        dotDir = ".config/zsh";

        history = {
            save = 10000;
            size = 10000;
            path = "home/.cache/zsh_history";
        };

        shellAliases = {
            ls = "eza -a --icons";
            sz = "source ~/.config/zsh/.zshrc";
            rebuild = "echo 'hi'";
        };
        # oh-my-zsh = {
        #     enable = true;
        #     plugins = [
        #         "zsh-fzf-history-search"
        #     ];
        # };
        plugins = [
        {
            # A prompt will appear the first time to configure it properly
            # make sure to select MesloLGS NF as the font in Konsole
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        # {
        #     name = "powerlevel10k-config";
        #     src = ./zsh;
        #     file = "p10k.zsh";
        # }
        {
            name = "zsh-fzf-history-search";
            src = pkgs.zsh-fzf-history-search;
            file = "share/zsh-fzf-history-search/zsh-fzf-history-search.zsh";
        }
        ];
    };
}
