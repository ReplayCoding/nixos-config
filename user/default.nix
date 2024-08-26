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
  ];

  users.users.user = {
    isNormalUser = true;
    home = "/home/user";
    shell = pkgs.fish;
    extraGroups = ["wheel" "video" "audio" "networkmanager" "libvirtd" "adbusers" "kvm" "docker" "wireshark"];
  };

  home-manager.extraSpecialArgs = {
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
