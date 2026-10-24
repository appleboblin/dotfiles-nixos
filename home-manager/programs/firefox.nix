{
  config,
  inputs,
  pkgs,
  ...
}:
let
  addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};

  settings = {
    # Native vertical tabs (sidebar)
    "sidebar.revamp" = true;
    "sidebar.verticalTabs" = true;

    # Load userChrome.css (bottom URL bar)
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

    # Enable extensions installed by Nix without a prompt
    "extensions.autoDisableScopes" = 0;

    "browser.toolbars.bookmarks.visibility" = "never";
    "browser.newtabpage.activity-stream.feeds.topsites" = true; # Shortcuts section
    "browser.newtabpage.activity-stream.topSitesRows" = 3; # up to 4 rows
    "browser.tabs.inTitlebar" = 0;
    "devtools.chrome.enabled" = true;
    "devtools.debugger.remote-enabled" = true;

  };

  # Move the toolbox (nav bar, bookmarks) below the page. With vertical tabs
  # there's no tab strip left up top, so this is the whole toolbar area.
  userChrome = ''
    #main-window body {
      flex-direction: column-reverse !important;
    }
    #navigator-toolbox {
      flex-direction: column-reverse !important;
    }

    /* bottom URL bar: open suggestions upwards (Firefox 158, popover) */
    #urlbar[popover-open] > .urlbarView {
      top: auto !important;
      bottom: anchor(top) !important;
      position-try-fallbacks: none !important;
      height: auto !important;
      max-height: 60vh !important;
      overflow: hidden auto !important;
      margin-bottom: 4px !important;
      border-radius: 12px !important;
      box-shadow: 0 -4px 16px rgb(0 0 0 / 0.35) !important;
    }
    #urlbar[popover-open] .urlbarView-background {
      border-radius: 12px !important;
    }

    /* hide group headings like "Firefox Suggest" */
    #urlbar[popover-open] .urlbarView-row[label]::before {
      display: none !important;
    }


    /* window controls: niri handles windows */
    .titlebar-buttonbox-container {
      display: none !important;
    }
    /* hide Simple Tab Groups' toolbar button */
    #simple-tab-groups_drive4ik-BAP {
      display: none !important;
    }
  '';

  extensions.packages = with addons; [
    firefox-color
    simple-tab-groups # workspaces
    ublock-origin
  ];

  mkProfile = id: {
    inherit
      id
      settings
      userChrome
      ;
    isDefault = id == 0;
    extensions = extensions // {
      force = true;
    };
  };
in
{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles = {
      personal = mkProfile 0;
      school = mkProfile 1;
    };
  };

  xdg.desktopEntries = {
    firefox-personal = {
      name = "Firefox: Personal";
      exec = "firefox -P personal %U";
      icon = "firefox";
    };
    firefox-school = {
      name = "Firefox: School";
      exec = "firefox -P school %U";
      icon = "firefox";
    };
  };
}
