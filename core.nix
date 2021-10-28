{ self, nixpkgs, neovim-nightly-overlay }: { config, pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ neovim-nightly-overlay.overlay ];
  system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

  nix = {
    package = pkgs.nixUnstable;
    autoOptimiseStore = true;
    binaryCaches = [ "https://nix-community.cachix.org" ];
    binaryCachePublicKeys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    registry.nixpkgs.flake = nixpkgs;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
