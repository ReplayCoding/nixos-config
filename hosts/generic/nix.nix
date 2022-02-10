{ nixConfig, ccacheDir, config, pkgs, lib, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    # allowAliases = false;
  };

  nix = {
    package = pkgs.nixVersions.stable;
    settings = nixConfig // {
      extra-sandbox-paths = [ ccacheDir ];
      accept-flake-config = true;
      auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;
    };
  };
  systemd.tmpfiles.rules = [ "d ${ccacheDir} 0775 root nixbld -" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
