{
  config,
  inputs,
  pkgs,
  flib,
  lib,
  ...
}: {
  imports = [
    ./system
    ./secrets
  ];

  users.users.user = {
    isNormalUser = true;
    home = "/home/user";
    shell = pkgs.fish;
    extraGroups = ["wheel" "video" "audio" "networkmanager" "libvirtd" "adbusers" "kvm" "docker" "wireshark"];
    openssh.authorizedKeys.keys = (import ../lib/pubkeys.nix).all;
  };

  home-manager.extraSpecialArgs = {
    inherit (config.age) secrets;
    inherit flib;
  };
  home-manager.users.user = {...}: {
    imports = [
      ./programs
      ./config
    ];

    systemd.user.startServices = "sd-switch";
    home.stateVersion = config.system.stateVersion;
  };
}
