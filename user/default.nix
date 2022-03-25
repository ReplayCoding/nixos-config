{
  config,
  inputs,
  pkgs,
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
    extraGroups = ["wheel" "video" "audio" "networkmanager"];
    openssh.authorizedKeys.keys = (import ../lib/pubkeys.nix).all;
  };

  home-manager.extraSpecialArgs = {
    inherit (config.age) secrets;
    inherit (inputs) nix-colors;
  };
  home-manager.users.user = {nix-colors, ...}: {
    imports = [
      ./programs
      ./config
      nix-colors.homeManagerModule
    ];

    colorscheme = nix-colors.colorSchemes.catppuccin;
    systemd.user.startServices = "sd-switch";
    home.stateVersion = config.system.stateVersion;
  };
}
