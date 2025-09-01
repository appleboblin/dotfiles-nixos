{
  pkgs,
  lib,
  config,
  ...
}:
let
  emacs-unwrapped = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.emacs-plus else pkgs.emacs30-pgtk;

  tangle =
    org:
    let
      stem = path: lib.head (lib.splitString "." path);
      outName = "${stem (builtins.baseNameOf org)}.el";
    in
    pkgs.runCommandNoCC "${outName}" { nativeBuildInputs = [ emacs-unwrapped ]; } ''
      cp ${org} tmp.org
      emacs -Q --batch --eval \
        "(progn
          (require 'ob-tangle)
          (org-babel-tangle-file \"tmp.org\" \"emacs-lisp\"))"
      install emacs-lisp $out
    '';
in
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      defaultInitFile = true;
      package = pkgs.emacs-pgtk;
      alwaysEnsure = true;
      alwaysTangle = true;

      # Optionally provide extra packages not in the configuration file.
      extraEmacsPackages =
        epkgs: with epkgs; [
          catppuccin-theme
          doom-modeline
          use-package
          swiper
          counsel
          smex
          ivy
          ivy-rich
          ivy-prescient
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

          evil-nerd-commenter # commenting
          lsp-mode
          lsp-ui
          lsp-ivy
          lsp-treemacs
          company
          company-box
        ];
    };
  };
  home.file = {
    "${config.home.homeDirectory}/.emacs.d/early-init.el" = {
      source = tangle ./early-init.org;
    };
    # "${config.home.homeDirectory}/.emacs.d/config.el" = {
    #   source = tangle ./init.org;
    # };
  };
  services.emacs = {
    enable = true;
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
