{
  flib,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    delta.options = {
      line-numbers = true;
    };
    delta.enable = true;
    userName = "ReplayCoding";
    userEmail = "replaycoding@gmail.com";
    extraConfig = {
      rebase.autoSquash = true;
      log.showsignature = true;
      commit.gpgsign = true;
      gpg.format = "ssh"; # Great name don't you think?
      user.signingkey = "key::${flib.pubkeys.user}";
      gpg.ssh.allowedSignersFile = toString (pkgs.writeText "git-allowed-signers" ''
        replaycoding@gmail.com ${flib.pubkeys.user}
      '');
      sendemail = {
        smtpuser = "replaycoding@gmail.com";
        smtpserver = "smtp.gmail.com";
        smtpencryption = "tls";
        smtpserverport = 587;
      };
    };
  };
}
