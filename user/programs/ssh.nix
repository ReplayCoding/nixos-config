{
  pkgs,
  secrets,
  ...
}: {
  programs.ssh = {
    enable = true;
    extraOptionOverrides.IdentityFile = secrets.user-ssh-key.path;
  };

  systemd.user.services.ssh-agent = {
    Unit.Description = "SSH Agent";
    Install.WantedBy = ["default.target"];
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/rm -f %t/ssh-agent";
      ExecStart = "${pkgs.openssh}/bin/ssh-agent -a %t/ssh-agent";
      ExecStartPost = "${pkgs.openssh}/bin/ssh-add ${secrets.user-ssh-key.path}";
      StandardOutput = "null";
      Type = "forking";
      Restart = "on-failure";
      SuccessExitStatus = "0 2";
      Environment = "DISPLAY=fake SSH_AUTH_SOCK=%t/ssh-agent";
    };
  };
  home.sessionVariables.SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
}
