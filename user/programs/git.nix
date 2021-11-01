{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    delta.options = {
      line-numbers = true;
    };
    delta.enable = true;
    userName = "ReplayCoding";
    userEmail = "replaycoding@gmail.com";
    includes = [
      {
        contents = {
          sendemail = {
            smtpuser = "replaycoding@gmail.com";
            smtpserver = "smtp.gmail.com";
            smtpencryption = "tls";
            smtpserverport = 587;
          };
        };
      }
    ];
  };
}
