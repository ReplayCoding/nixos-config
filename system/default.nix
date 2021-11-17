_:

{
  imports = [
    ./sound.nix
    ./console.nix
    ./zfs.nix
    ./network.nix
    ./dns.nix
    ./ssh.nix
  ];

  services.logind.killUserProcesses = true;
}
