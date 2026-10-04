{ pkgs, ... }:
{
  programs.fastfetch = {
    enable = true;

    package = pkgs.fastfetch.override { zfsSupport = true; };

    settings = {
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "display"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "swap"
        {
          type = "zpool";
          key = "Disk";
          format = "{size-used} / {size-total} ({used-percentage}) - {state}";
        }
        "localip"
        "battery"
        "break"
        "colors"
      ];
    };
  };
}
