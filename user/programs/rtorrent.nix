_: {
  programs.rtorrent = {
    enable = true;
    extraConfig = "
      session.path.set = ./.rtorrent_session
    ";
  };
}
