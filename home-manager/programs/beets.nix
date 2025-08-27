{
  user,
  ...
}:
{
  programs.beets = {
    enable = true;

    settings = {
      "directory" = "/home/${user}/Music/music/";
      "library" = "/home/${user}/Music/beets/musiclibrary.db";
      "import" = {
        "move" = true;
        "write" = true;
      };
      "plugins" = "fetchart lyrics lastgenre fromfilename deezer spotify edit";
      "paths" = {
        "default" = "$albumartist/$album%aunique{}/$track$title";
        "singleton" = "$artist/Non-Album/$title";
        "comp" = "Compilations/$album%aunique{}/$track$title";
      };

    };
  };
}
