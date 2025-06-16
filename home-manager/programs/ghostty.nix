{
  pkgs,
  lib,
  ...
}:
{
  programs.ghostty = {
    enable = true;

    enableFishIntegration = true;

    settings = {
      # use fish for shell instead of bash
      command = "${lib.getExe pkgs.fish} --login --interactive";

      # theme = "nord";
      font-size = lib.mkDefault "16";
      font-family = "MesloLGS Nerd Font Mono";

      window-padding-x = 5;
      window-padding-y = 5;
      background-blur = true;
      background-opacity = 0.95;

      # https://github.com/ghostty-org/ghostty/discussions/6855#discussioncomment-12574673
      shell-integration-features = "no-cursor";
      cursor-style = "block";
      cursor-style-blink = true;

    };
  };
}
