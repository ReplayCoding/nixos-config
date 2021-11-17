_:

{
  imports = [
    ./sound.nix
    ./console.nix
    ./zfs.nix
    ./network.nix
    ./dns.nix
    ./ssh.nix
    ./nix.nix
  ];

  services.logind.killUserProcesses = true;
}
