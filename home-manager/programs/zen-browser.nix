{
  inputs,
  pkgs,
  ...
}:
let
  firefox-addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = false;
    profiles.default = {
      id = 0;
      isDefault = true;
      userChrome = ''
        /* Recolor Zen's active window/split-view border to match niri */
        :root {
          --zen-colors-border: #f5bde6 !important;
          --zen-primary-color: #f5bde6 !important;
        }
      '';
      extensions.packages = with firefox-addons; [
        ublock-origin
        darkreader
        consent-o-matic
        dearrow
        sponsorblock
        # enhancer-for-youtube
        proton-pass
        proton-vpn
        # keepa
      ];
    };
    profiles.work = {
      id = 1;
      isDefault = false;
      userChrome = ''
        /* Recolor Zen's active window/split-view border to match niri */
        :root {
          --zen-colors-border: #f5bde6 !important;
          --zen-primary-color: #f5bde6 !important;
        }
      '';
      extensions.packages = with firefox-addons; [
        ublock-origin
        darkreader
        consent-o-matic
        # dearrow
        # sponsorblock
        # enhancer-for-youtube
        proton-pass
        # proton-vpn
        # keepa
      ];
    };
  };
}
