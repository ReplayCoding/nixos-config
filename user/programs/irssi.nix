{ ... }:

let
  username = "replaycoding";
  nick = username;
  realname = "ReplayCoding";
in
{
  programs.irssi = {
    enable = true;
    networks = {
      libera = {
        inherit nick;
        server = {
          address = "irc.libera.chat";
          port = 6697;
        };
      };
      rizon = {
        nick = "acpi";
        server = {
          address = "irc.rizon.net";
          port = 6697;
        };
      };
    };
    extraConfig = ''
      settings = {
        "core" = {
          real_name = "${realname}";
          user_name = "${username}";
          nick = "${nick}";
        };
        "irc/dcc" = {
          dcc_autoget = "yes";
          dcc_download_path = "~/Downloads/irc";
        };
      };
    '';
  };
}
