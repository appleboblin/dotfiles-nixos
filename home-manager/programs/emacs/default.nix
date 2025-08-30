{
  pkgs,
  config,
  ...
}:
let
  emacs = pkgs.emacsWithPackagesFromUsePackage {
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
        general
        evil
        evil-collection
        hydra
        projectile
        counsel-projectile

        magit
        forge

        visual-fill-column
        org
        org-bullets

      ];
  };
in
{
  programs.emacs = {
    enable = true;
    package = emacs;
  };
  home.file = {
    "${config.home.homeDirectory}/.emacs.d/early-init.el" = {
      source = ./early-init.el;
    };
  };
  services.emacs = {
    enable = true;
    # package = emacs;
  };

  # emacs gitignore
  programs.git.ignores = [
    "*~"
    "/.emacs.desktop"
    "/.emacs.desktop.lock"
    "*.elc"
    "auto-save-list"
    "tramp"
    ".\\#*"
    "\\#*\\#"
    # org-mode
    ".org-id-locations"
    "*_archive"
    # directory config
    ".dir-locals.el"
  ];
}
