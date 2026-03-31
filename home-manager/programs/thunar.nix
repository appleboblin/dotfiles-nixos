{
  xdg.dataFile."xfce4/helpers/footclient.desktop".text = ''
    [Desktop Entry]
    NoDisplay=true
    Version=1.0
    Type=X-XFCE-Helper
    X-XFCE-Category=TerminalEmulator
    X-XFCE-Commands=footclient
    X-XFCE-CommandsWithParameter=footclient -e "%s"
    Icon=foot
    Name=Foot Client
  '';

  xdg.configFile."xfce4/helpers.rc".text = ''
    TerminalEmulator=footclient
    TerminalEmulatorDismissed=true
  '';
}
