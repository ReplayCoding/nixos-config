self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv mesonOptions_pgo llvmPackages fakeExtra createWithBuildIdList;
  mkOptimisedMesa =
    pgoMode:
    {
      mesa-optimised =
        (super.mesa.overrideAttrs (mesonOptions_pgo null pgoMode fakeExtra)).override (
          { inherit llvmPackages stdenv; }
          // super.nixosPassthru.mesaConfig
        );
    };
in
createWithBuildIdList super mkOptimisedMesa
