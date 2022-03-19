{
  config,
  pkgs,
  secrets,
  ...
}: {
  accounts.email = {
    maildirBasePath = "${config.home.homeDirectory}/Mail";
    accounts = {
      work = {
        address = "replaycoding@gmail.com";
        realName = "ReplayCoding";
        primary = true;
        passwordCommand = "${pkgs.coreutils}/bin/cat ${secrets.work-email-password.path}";
        flavor = "gmail.com";
        mbsync = {
          enable = true;
          flatten = ".";
          create = "both";
          remove = "both";
          expunge = "both";
        };
      };
    };
  };

  programs.mbsync.enable = true;
  services.mbsync = {
    enable = true;
    frequency = "hourly";
  };
}
