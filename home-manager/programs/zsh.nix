{
    config,
    pkgs,
    lib,
    ...
}: #let
#     # load the configuration that we was generated the first
#     # time zsh were loaded with powerlevel enabled.
#     # Make sure to comment this part (and the sourcing part below)
#     # before you ran powerlevel for the first time or if you want to run
#     # again 'p10k configure'. Then, copy the generated file as:
#     # $ mv ~/.p10k.zsh p10k-config/p10k.zsh
#     # configThemeNormal = ./p10k-config/p10k.zsh;
#     # configThemeTTY = ./p10k-config/p10k_tty.zsh;
# in 
{
    home.packages = with pkgs; [
        zsh-powerlevel10k
        # zsh-autosuggestions
    ];
    programs.zsh = {
        # enable = true;
        # initExtra = ''
        # # The powerlevel theme I'm using is distgusting in TTY, let's default
        # # to something else
        # # See https://github.com/romkatv/powerlevel10k/issues/325
        # # Instead of sourcing this file you could also add another plugin as
        # # this, and it will automatically load the file for us
        # # (but this way it is not possible to conditionally load a file)
        # # {
        # #   name = "powerlevel10k-config";
        # #   src = lib.cleanSource ./p10k-config;
        # #   file = "p10k.zsh";
        # # }
        # if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
        #     [[ ! -f ${configThemeNormal} ]] || source ${configThemeNormal}
        # else
        #     [[ ! -f ${configThemeTTY} ]] || source ${configThemeTTY}
        # fi
        # '';
        # promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        enableAutosuggestions = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        dotDir = ".config/zsh";
        shellAliases =
            config.environment.shellAliases
            // {
            sz = "source ~/.config/zsh/.zshrc";
            ls = "eza";
            };
        history.size = 10000;
        history.save = 10000;
        plugins = [
        # {
        #     # A prompt will appear the first time to configure it properly
        #     # make sure to select MesloLGS NF as the font in Konsole
        #     name = "powerlevel10k";
        #     src = pkgs.zsh-powerlevel10k;
        #     file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        # }
        {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
        }
        ];
    };
}
