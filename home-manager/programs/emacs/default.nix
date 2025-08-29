{
  pkgs,
  config,
  ...
}:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      defaultInitFile = true;
      package = pkgs.emacs-pgtk;
      alwaysEnsure = true;
      alwaysTangle = false;

      # Optionally provide extra packages not in the configuration file.
      extraEmacsPackages =
        epkgs: with epkgs; [
          catppuccin-theme
          doom-modeline
          use-package
          swiper
          counsel
          ivy
          ivy-rich
          diminish
          rainbow-delimiters
          which-key
          helpful
        ];
    };
  };
  home.file = {
    "${config.home.homeDirectory}/.emacs.d/early-init.el" = {
      source = ./early-init.el;
    };
  };
  services.emacs = {
    enable = true;
  };
}
