{pkgs, inputs, ...}: {
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
      userSettings = {
        "editor.fontSize" = 16;
        "window.zoomLevel" = 1;
        "terminal.integrated.fontSize" = 16;
        "markdown.preview.fontSize" = 16;
        "workbench.colorTheme" = "Nord";
        "workbench.productIconTheme" = "material-product-icons";
        "editor.fontFamily" = "'MesloLGS Nerd Font Mono', 'monospace', monospace";
        "terminal.integrated.defaultProfile.linux" = "fish"; 
      };
    };
  };
}