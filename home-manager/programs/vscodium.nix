{pkgs, inputs, ...}: {
  config = {
    programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
        arcticicestudio.nord-visual-studio-code
        bbenoist.Nix
        njpwerner.autodocstring
        EditorConfig.EditorConfig
        donjayamanne.githistory
        codezombiech.gitignore
        eamodio.gitlens
        alefragnani.project-manager
        ms-python.python
        ms-python.vscode-pylance
        oderwat.indent-rainbow
    ];
    userSettings = {
        "editor.fontSize": 16;
    };
    };
  };
}