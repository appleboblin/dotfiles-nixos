{
    programs.bash = {
        enable = true;
        bashrcExtra = ''
            function gt () {
            cd $HOME/dotfiles-nixos/
            if [[ $# -eq 1 ]]; then
                cd $1;
            fi
            }
            _gt () {
            ( cd "$HOME/dotfiles-nixos"; printf "%s\n" "$2"* )
            }
            complete -o nospace -C _gt gt
        '';
        enableCompletion = true;
    };
}
