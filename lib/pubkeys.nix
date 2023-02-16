rec {
  thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdg6DUkevCSHbWOiodfJsBrwiX6HWpdY/yGKfuMe+zX";
  librem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNXE6bXe8ba+/mWK3Lw1ht0T1IbDYIHnsAB96Qcgcz0";
  systems = [thinkpad librem];

  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn1NkYoDtEQTBRyrltqBQRN4XcuR8nae5l/cXXu3qmD replaycoding@gmail.com";
  users = [user];

  all = systems ++ users;
}
