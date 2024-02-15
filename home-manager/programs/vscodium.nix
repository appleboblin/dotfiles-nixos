{lib, pkgs, inputs, ...}: {
  config = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        arcticicestudio.nord-visual-studio-code
        bbenoist.nix
        editorconfig.editorconfig
        donjayamanne.githistory
        codezombiech.gitignore
        eamodio.gitlens
        alefragnani.project-manager
        ms-python.python
        ms-python.vscode-pylance
        oderwat.indent-rainbow
        naumovs.color-highlight
        pkief.material-product-icons
      ];
      userSettings = lib.mkDefault {
        "editor.fontSize" = 15;
        "window.zoomLevel" = 1;
        "terminal.integrated.fontSize" = 14;
        "markdown.preview.fontSize" = 15;
        "workbench.colorTheme" = "Nord";
        "workbench.productIconTheme" = "material-product-icons";
        "editor.fontFamily" = "'MesloLGS Nerd Font Mono', 'monospace', monospace";
        "terminal.integrated.defaultProfile.linux" = "fish"; 
      };
    };
  };
}