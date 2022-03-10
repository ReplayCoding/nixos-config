rec {
  thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdg6DUkevCSHbWOiodfJsBrwiX6HWpdY/yGKfuMe+zX";
  librem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINzFLr8qwNGUgB4j5oSJEPfSSQeueWBNycXikYbalXMy";
  systems = [ thinkpad librem ];

  root_librem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICkafqvoqbMINmwSHzA4xH2cTHwPhFc+ZIj66/5qsgjp root@librem";
  roots = [ root_librem ];

  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn1NkYoDtEQTBRyrltqBQRN4XcuR8nae5l/cXXu3qmD";
  users = [ user ];

  all = systems ++ users ++ roots;
}
