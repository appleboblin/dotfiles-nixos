{pkgs, inputs, ...}: {
  config = {
      programs.firefox = {
        enable = true;
        package=pkgs.firefox.override {cfg.enableTridactyNative = true;};
        profiles."appleboblin" = {
        isDefault = true;
        settings = {
            # Keep the reader button enabled at all times; really don't
            # care if it doesn't work 20% of the time, most websites are
            # crap and unreadable without this
            "reader.parse-on-load.force-enabled" = true;

            # Hide the "sharing indicator", it's especially annoying
            # with tiling WMs on wayland
            "privacy.webrtc.legacyGlobalIndicator" = false;

            # Actual settings
            "app.shield.optoutstudies.enabled" = false;
            "app.update.auto" = false;
            "browser.bookmarks.restore_default_bookmarks" = false;
            "browser.contentblocking.category" = "strict";
            "browser.ctrlTab.recentlyUsedOrder" = false;
            "browser.discovery.enabled" = false;
            "browser.download.dir" = "$HOME/Downloads";
            "browser.laterrun.enabled" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
            "browser.newtabpage.activity-stream.feeds.snippets" = false;
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.pinned" = false;
            "browser.protections_panel.infoMessage.seen" = true;
            "browser.quitShortcut.disabled" = true;
            "browser.search.geoip.url" = "";
            "browser.send_pings.require_same_host" = true;
            "browser.send_pings" = false;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.ssb.enabled" = true;
            "browser.toolbars.bookmarks.visibility" = "newtab";
            "browser.urlbar.placeholderName" = "DuckDuckGo";
            "browser.urlbar.suggest.openpage" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnable" = false;
            "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
            "dom.battery.enabled" = false;
            "dom.event.clipboardevents.enabled" = false;
            "dom.security.https_only_mode_ever_enabled" = true;
            "dom.security.https_only_mode" = true;
            "extensions.getAddons.showPane" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "extensions.pocket.enabled" = false;
            "geo.enabled" = false;
            "geo.wifi.uri" = "";
            "identity.fxaccounts.enabled" = false;
            "media.navigator.enabled" = false;
            "network.cookie.alwaysAcceptSessionCookies" = false;
            "network.http.referer.spoofSource" = false;
            "network.http.sendRefererHeader" = 0;
            "network.http.sendSecureXSiteReferrer" = false;
            "plugins.enumerable_names" = "";
            "privacy.firstparty.isolate" = true;
            "privacy.resistFingerprinting" = true;
            "privacy.trackingprotection.cryptomining.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.fingerprinting.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
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
            clearurls
            theme-nord-polar-night
        ];
        };
    };
  };

}