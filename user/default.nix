{ config, pkgs, lib, ... }:

{
  imports = [
    ./system
  ];

  users.users.user = {
    isNormalUser = true;
    home = "/home/user";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.user = { pkgs, ... }: {
    imports = [
      ./programs
      ./xdg.nix
      ./gui.nix
    ];

    home.stateVersion = config.system.stateVersion;
  };
}
