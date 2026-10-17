{
  pkgs,
  ...
}:
{
  programs.btop = {
    enable = true;
    package = pkgs.btop-rocm;
    settings = {
      theme_background = false;
      freq_mode = "average";
      show_cpu_freq = true;
    };
  };
}
