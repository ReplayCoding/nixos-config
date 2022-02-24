self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv mesonOptions_pgo llvmPackages fakeExtra createWithBuildIdList;
  mkOptimisedMesa =
    { pgoMode ? (super.nixosPassthru.pgoMode or "off") }:
    {
      mesa-optimised =
        (super.mesa.overrideAttrs (mesonOptions_pgo null pgoMode fakeExtra)).override (
          { inherit llvmPackages stdenv; }
          // (super.nixosPassthru.mesaConfig or { })
        );
    };
in
createWithBuildIdList super mkOptimisedMesa
