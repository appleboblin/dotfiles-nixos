{
  user,
  ...
}:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting ""
      nix-your-shell fish | source
    '';
    functions = {
      gt = {
        body = ''
          cd $HOME/github/
          if test (count $argv) -eq 1
              cd $argv[1]
          end
        '';
        description = "cd into GitHub directories";
      };
    };
    # completions = {
    #     grr = {
    #         body = ''
    #             find "$HOME/dotfiles-nixos/" -maxdepth 1 -type d -exec basename {} \;
    #         '';
    #     };
    # };
  };

  xdg.configFile = {
    # "/home/${user}/.config/fish/functions/gt.fish".text = ''
    #     function gt --description 'cd into GitHub directories'
    #         cd $HOME/dotfiles-nixos/
    #         if test (count $argv) -eq 1
    #             cd $argv[1]
    #         end
    #     end
    #     complete -c gt --exclusive -a "(__fish_complete_directories ($HOME/dotfiles-nixos/))"
    # '';
    "/home/${user}/.config/fish/completions/gt.fish".text = ''
      function _gt --description 'complete GitHub directories'
          find "$HOME/github/" -maxdepth 1 -type d -not -wholename "$HOME/github/" -exec basename {} \;
      end
      complete --no-files --command gt --arguments "(_gt)"
    '';
  };
}
