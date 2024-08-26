{
  pkgs,
  config,
  ...
}: {
  programs.ssh = {
    enable = true;
    matchBlocks."*".identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
  };
  services.ssh-agent.enable = true;
}
