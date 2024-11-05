{
    user,
    ...
}: {
    services.syncthing = {
        enable = true;
        user = "${user}";
        openDefaultPorts = true;
        dataDir = "/home/${user}";
        configDir = "/home/${user}/.config/syncthing";
        overrideDevices = true;     # overrides any devices added or deleted through the WebUI
        overrideFolders = true;     # overrides any folders added or deleted through the WebUI
        settings = {
            gui = {
                user = "${user}";
                password = "password";
            };
            guiAddress = "127.0.0.1:8384";
            devices = {
                "desktop" = { id = "2CZOAAJ-62XNSMA-KIVTK3V-TMHF2QJ-ZHVSWQP-ELVEQSE-WRO2FM6-C6GCLQT" ;};
                "framework" = { id = "QPHXHHN-PXJ2Z7H-SS3FAA4-UERSJEQ-5QJXVK2-V2ZPHDP-UHIRROZ-AR463Q6" ;};
                "pixel8" = { id = "NHSSWYI-LT3UUJZ-UQNT7AS-HNJEGBI-XRX4O6O-XIT5Y2X-6QZZIGR-PHK3YQ3" ;};
                "TrueNAS" = { id = "RHZOUQK-LDC2CNF-UG2YI6F-FGWDVOS-LCKYAKF-4LPCUV3-74I4O2O-32WZLQZ" ;};
            };
            folders = {
                "Share" = {
                    path = "/home/${user}/Share";
                    devices = [ "desktop" "framework" "pixel8" ];
                };
                "Obsidian" = {
                    path = "/home/${user}/Documents/obsidian/";
                    devices = [ "desktop" "TrueNAS" "framework" "pixel8" ];
                };
                "Pictures" = {
                    path = "/home/${user}/Pictures";
                    devices = [ "desktop" "TrueNAS" "framework" ];
                };
                "Documents" = {
                    path = "/home/${user}/Documents";
                    devices = [ "desktop" "TrueNAS" "framework" ];
                };
                # "Music" = {
                #     path = "/home/${user}/Music";
                #     devices = [ "TrueNAS" "framework" ];
                # };
                "Videos" = {
                    path = "/home/${user}/Videos";
                    devices = [ "desktop" "TrueNAS" "framework" ];
                };
                "vm" = {
                    path = "/home/${user}/vm";
                    devices = [ "desktop" "TrueNAS" "framework" ];
                };
            };
        };

    };
}
