{ config, pkgs, lib, ... }:

{
  imports = [
    ./system
    ./secrets
  ];

  users.users.user = {
    isNormalUser = true;
    home = "/home/user";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" ];
  };

  home-manager.extraSpecialArgs = { inherit (config.age) secrets; };
  home-manager.users.user = {
    imports = [
      ./programs
      ./xdg.nix
      ./theme.nix
    ];

    home.stateVersion = config.system.stateVersion;
  };
}
