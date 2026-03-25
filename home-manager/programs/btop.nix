{
  pkgs,
  ...
}:
{
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      freq_mode = "average";
      show_cpu_freq = true;
    };
  };

  programs.fish = {
    shellAliases = {
      btop = "env LD_LIBRARY_PATH=${pkgs.rocmPackages.rocm-smi}/lib:\$LD_LIBRARY_PATH btop";
    };
  };
}
