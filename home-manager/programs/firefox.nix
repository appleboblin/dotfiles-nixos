{pkgs, inputs, ...}: {
  config = {
      programs.firefox = {
        enable = true;
        package=pkgs.firefox.override {cfg.enableTridactyNative = true;};
        profiles."appleboblin" = {
        isDefault = true;
        settings = {
            # "browser.display.background_color" = "#bdbdbd";
            "browser.download.dir" = "$HOME/downloads";
            "browser.search.suggest.enabled" = false;
            "browser.startup.page" = 3;
            "browser.urlbar.placeholderName" = "DuckDuckGo";
            "devtools.theme" = "dark";
            "experiments.activeExperiment" = false;
            "experiments.enabled" = false;
            "experiments.supported" = false;
            "extensions.pocket.enabled" = false;
            "general.smoothScroll" = false;
            "layout.css.devPixelsPerPx" = "1";
            "media.videocontrols.picture-in-picture.enabled" = false;
            "network.IDN_show_punycode" = true;
            "network.allow-experiments" = false;
            "signon.rememberSignons" = false;
            "widget.content.gtk-theme-override" = "Adwaita:dark";
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            ublock-origin
            darkreader
            proton-vpn
            # bypass-paywalls-clean
            unpaywall
            canvasblocker
            decentraleyes
            sponsorblock
            enhancer-for-youtube
            user-agent-string-switcher
        ];
        };
    };
  };

}