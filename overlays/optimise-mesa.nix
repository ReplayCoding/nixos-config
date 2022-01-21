self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv mesonOptions llvmPackages makeStatic;
in
{
  mesa-optimised =
    (super.mesa.overrideAttrs mesonOptions).override { inherit llvmPackages stdenv; };
}
