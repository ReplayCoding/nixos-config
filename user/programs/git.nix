{
  pkgs,
  config,
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
      user.signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519";
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
      sendemail = {
        smtpuser = "replaycoding@gmail.com";
        smtpserver = "smtp.gmail.com";
        smtpencryption = "tls";
        smtpserverport = 587;
      };
    };
  };
}
