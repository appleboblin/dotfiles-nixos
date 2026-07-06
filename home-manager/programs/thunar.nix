{
  xdg = {
    # fix mimetype associations
    mimeApps.defaultApplications = {
      "inode/directory" = "thunar.desktop";
      # wtf zathura / pqiv registers themselves to open archives
      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/vnd.rar" = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-bzip2-compressed-tar" = "org.gnome.FileRoller.desktop";
    };
    dataFile."xfce4/helpers/footclient.desktop".text = ''
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
    configFile = {
      "mimeapps.list".force = true;
      "Thunar/thunarrc".text = ''
        [Configuration]
        DefaultView=ThunarDetailsView
        LastView=ThunarDetailsView
        LastShowHidden=TRUE
        LastSeparatorPosition=180
        MiscDateStyle=THUNAR_DATE_STYLE_ISO
        MiscShowThumbnails=TRUE
        MiscSingleClick=FALSE
        MiscFoldersFirst=TRUE
      '';
      "xfce4/helpers.rc".text = ''
        TerminalEmulator=footclient
        TerminalEmulatorDismissed=true
      '';
    };
  };

  dconf.settings = {
    # fix open in terminal
    "org/gnome/desktop/applications/terminal" = {
      exec = "footclient";
    };
    "org/cinnamon/desktop/applications/terminal" = {
      exec = "footclient";
    };
  };
}
