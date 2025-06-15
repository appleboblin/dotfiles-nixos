{
  pkgs,
  inputs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  # allow spotify to be installed if you don't have unfree enabled already
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  # 	"spotify"
  # ];

  # document: https://gerg-l.github.io/spicetify-nix/usage.html
  # import the flake's module for your system
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  # configure spicetify :)
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.text;
    colorScheme = "RosePineMoon";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      hidePodcasts
      # keyboardShortcut
    ];
  };
}
