{pkgs, inputs, ...}: {
  config = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        arcticicestudio.nord-visual-studio-code
        bbenoist.nix
        njpwerner.autodocstring
        editorconfig.editorconfig
        donjayamanne.githistory
        codezombiech.gitignore
        eamodio.gitlens
        alefragnani.project-manager
        ms-python.python
        ms-python.vscode-pylance
        oderwat.indent-rainbow
        pkief.material-product-icons
      ];
      userSettings = {
        "editor.fontSize" = 16;
        "window.zoomLevel" = 0;
        "terminal.integratec.fontSize" = 16;
        "markdown.preview.fontSize" = 16;
        "workbench.colorTheme" = "Nord";
        "workbench.productIconTheme" = "material-product-icons";
      };
    };
  };
}