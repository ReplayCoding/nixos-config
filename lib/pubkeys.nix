rec {
  thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdg6DUkevCSHbWOiodfJsBrwiX6HWpdY/yGKfuMe+zX";
  librem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINzFLr8qwNGUgB4j5oSJEPfSSQeueWBNycXikYbalXMy";
  systems = [ thinkpad librem ];

  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn1NkYoDtEQTBRyrltqBQRN4XcuR8nae5l/cXXu3qmD";
  all = systems ++ [ user ];
}
