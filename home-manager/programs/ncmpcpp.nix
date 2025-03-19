{
  host,
  ...
}:
{
  # ncmpcpp
  programs.ncmpcpp = {
    enable = host != "vm";
    settings = {
      ncmpcpp_directory = "~/.local/share/ncmpcpp";
      # mpdMusicDir = "/home/${user}/Music";
    };
  };

  # programs.ncmpcpp = {
  #     enable = true;
  #     settings = {
  #     screen_switcher_mode = "playlist, media_library";
  #     media_library_primary_tag = "album_artist";
  #     progressbar_look = "▄▄";
  #     display_bitrate = "yes";
  #     lyrics_directory = "${config.xdg.cacheHome}/lyrics";
  #     follow_now_playing_lyrics = "yes";
  #     lyrics_fetchers = "musixmatch, azlyrics";
  #     };
  # };
}
