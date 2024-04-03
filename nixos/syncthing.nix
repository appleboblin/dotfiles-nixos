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
        overrideDevices = false;     # overrides any devices added or deleted through the WebUI
        overrideFolders = false;     # overrides any folders added or deleted through the WebUI
        settings = {
            gui = {
                user = "${user}";
                password = "password";
            };
            guiAddress = "127.0.0.1:8384";
            devices = {
                # "desktop" = { id = "4BJ2S6E-FUSNAIZ-36GD7J6-46EV7SI-XZFBLMH-NAC4LY5-ANTUJGE-ABQWQAY" ;};
                "framework" = { id = "QPHXHHN-PXJ2Z7H-SS3FAA4-UERSJEQ-5QJXVK2-V2ZPHDP-UHIRROZ-AR463Q6" ;};
                "pixel8" = { id = "JZTSEZL-4BP62F2-5THXJHA-T7NHMXZ-CI26FMQ-T5747GG-7BUPB6U-JY56IAI" ;};
                "TrueNAS" = { id = "B7LEEWO-5WO262Q-GQZCXGJ-KZTA2CF-MIN7HN6-YGJXHAL-W7A3PZ6-ZPRTZQZ" ;};
            };
            folders = {
                "Share" = {
                    path = "/home/${user}/Share";
                    devices = [ "framework" "pixel8" ];
                };
                "Obsidian" = {
                    path = "/home/${user}/Documents/obsidian";
                    devices = [ "framework" "pixel8" ];
                };
                "Pictures" = {
                    path = "/home/${user}/Pictures";
                    devices = [ "TrueNAS" "framework" ];
                };
                "Documents" = {
                    path = "/home/${user}/Documents";
                    devices = [ "TrueNAS" "framework" ];
                };
                "Music" = {
                    path = "/home/${user}/Music";
                    devices = [ "TrueNAS" "framework" ];
                };
                "Videos" = {
                    path = "/home/${user}/Videos";
                    devices = [ "TrueNAS" "framework" ];
                };
                "vm" = {
                    path = "/home/${user}/vm";
                    devices = [ "TrueNAS" "framework" ];
                };
            };
        };

    };
}