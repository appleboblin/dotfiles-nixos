{
    config,
    pkgs,
    lib,
    host,
    user,
    home,
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
            guiAddress = "0.0.0.0:8384";
            devices = {
                "desktop" = { id = "4BJ2S6E-FUSNAIZ-36GD7J6-46EV7SI-XZFBLMH-NAC4LY5-ANTUJGE-ABQWQAY" ;};
                "framework" = { id = "QPHXHHN-PXJ2Z7H-SS3FAA4-UERSJEQ-5QJXVK2-V2ZPHDP-UHIRROZ-AR463Q6" ;};
                "pixel8" = { id = "JZTSEZL-4BP62F2-5THXJHA-T7NHMXZ-CI26FMQ-T5747GG-7BUPB6U-JY56IAI" ;};
            };
            folders = {
                "Share" = {
                    path = "/home/${user}/Share";
                    devices = [ "desktop" "framework" "pixel8" ];
                };
                "Obsidian" = {
                    path = "/home/${user}/Documents/obsidian";
                    devices = [ "desktop" "framework" "pixel8" ];
                };
                "Pictures" = {
                    path = "/home/${user}/Pictures";
                    devices = [ "desktop" "framework" ];
                };
                "Documents" = {
                    path = "/home/${user}/Documents";
                    devices = [ "desktop" "framework" ];
                };
                "Music" = {
                    path = "/home/${user}/Music";
                    devices = [ "desktop" "framework" ];
                };
                "Videos" = {
                    path = "/home/${user}/Videos";
                    devices = [ "desktop" "framework" ];
                };
            };
        };

    };
}