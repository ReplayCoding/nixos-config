{
  flib,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    difftastic.enable = true;
    userName = "ReplayCoding";
    userEmail = "replaycoding@gmail.com";
    extraConfig = {
      submodule.recurse = true;
      diff.submodule = "log";
      status.submoduleSummary = true;

      rebase.autoSquash = true;

      commit.gpgsign = true;
      gpg.format = "ssh"; # Great name don't you think?
      push.autoSetupRemote = "true";
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
