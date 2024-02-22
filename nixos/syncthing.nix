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
            guiAddress = "0.0.0.0:8384";
            devices = {
                "desktop" = { id = "4BJ2S6E-FUSNAIZ-36GD7J6-46EV7SI-XZFBLMH-NAC4LY5-ANTUJGE-ABQWQAY" ;};
                "framework" = { id = "QPHXHHN-PXJ2Z7H-SS3FAA4-UERSJEQ-5QJXVK2-V2ZPHDP-UHIRROZ-AR463Q6" ;};
            };
            folders = {
                "Share" = {
                    path = "/home/${user}/Share";
                    devices = [ "desktop" "framework" ];
                };
            };
        };

    };
}