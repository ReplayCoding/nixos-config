_:

{
  programs.rtorrent = {
    enable = true;
    settings = "
      session.path.set = ./.rtorrent_session
    ";
  };
}
