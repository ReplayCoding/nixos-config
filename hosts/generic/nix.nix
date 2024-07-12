{
  nixConfig,
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  systemFlakeDrv = let
    compatFile = pkgs.writeText "compat-default" ''
      let
        flake = builtins.getFlake (toString ./.);
      in
      # ugly hack to get around string interpolation
      builtins.getAttr builtins.currentSystem flake.packages
    '';
  in
    pkgs.stdenv.mkDerivation {
      name = "system-flake-drv";

      unpackPhase = ''
        cp ${compatFile} default.nix
        cp ${./registry-flake.nix} flake.nix
        substituteInPlace flake.nix \
          --subst-var-by NIXOS ${inputs.self} \
          --subst-var-by NIXPKGS ${inputs.nixpkgs} \
          --subst-var-by HOSTNAME ${pkgs.nixosPassthru.hostname}
      '';
      buildPhase = ''
        NIX_STORE_DIR=$(mktemp -d) NIX_STATE_DIR=$(mktemp -d) ${config.nix.package}/bin/nix \
          --extra-experimental-features nix-command \
          --extra-experimental-features flakes \
          flake lock flake.nix
      '';
      installPhase = ''
        mkdir $out
        cp default.nix flake.nix flake.lock $out
      '';
    };
  filteredInputs = (builtins.removeAttrs inputs ["self"]) // {nixos = systemFlakeDrv;};
in {
  nixpkgs.config = {
    allowUnfree = true;
    # allowBroken = true; # zfs
    permittedInsecurePackages = [
      # For Unity
      # "openssl-1.1.1w"
    ];
    # allowAliases = false;
  };

  nix = {
    nixPath =
      builtins.map
      (name: "${name}=${filteredInputs.${name}}")
      (builtins.attrNames filteredInputs);
    registry =
      builtins.mapAttrs
      (_: value: {flake = value;})
      filteredInputs;
    settings =
      nixConfig
      // {
        extra-sandbox-paths = [pkgs.nixosPassthru.ccacheDir];
        flake-registry =
          pkgs.writeText
          "flake-registry"
          (builtins.toJSON {
            version = 2;
            flakes = [];
          });
        accept-flake-config = true;
        # keep-outputs = true;
        keep-derivations = true;
      };
  };
  systemd.tmpfiles.rules = ["d ${pkgs.nixosPassthru.ccacheDir} 0775 root nixbld -"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
