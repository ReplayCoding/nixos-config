{secrets, ...}: {
  programs.ssh = {
    enable = true;
    extraOptionOverrides.IdentityFile = secrets.user-ssh-key.path;
  };
}
