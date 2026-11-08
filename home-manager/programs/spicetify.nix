{
  pkgs,
  inputs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
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
    # theme = spicePkgs.themes.text;
    # colorScheme = "RosePineMoon";
    theme = spicePkgs.themes.text;
    # colorScheme defaults to "custom" when customColorScheme is set
    customColorScheme = {
      accent = "f5bde6"; # pink
      accent-active = "f5bde6";
      accent-inactive = "24273a"; # base
      banner = "f5bde6";
      border-active = "f5bde6";
      border-inactive = "363a4f"; # surface0
      header = "5b6078"; # surface2
      highlight = "5b6078";
      main = "24273a"; # base
      notification = "8aadf4"; # blue
      notification-error = "ed8796"; # red
      subtext = "a5adcb"; # subtext0
      text = "cad3f5"; # text
    };

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      hidePodcasts
      # keyboardShortcut
    ];
  };
}
