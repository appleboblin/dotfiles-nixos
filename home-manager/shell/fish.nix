{
  ...
}:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting ""
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
      ssh = "TERM=xterm-256color command ssh $argv";
      init = "nix flake init -t dots#$argv[1]";
    };
  };

  xdg.configFile = {
    "fish/completions/gt.fish".text = ''
      complete --no-files --command gt --arguments "(path basename $HOME/github/*/)"
    '';
  };
}
