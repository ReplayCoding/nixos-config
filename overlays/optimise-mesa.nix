self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv llvmPackages makeStatic;
in
{
  mesa-optimised = (super.mesa.overrideAttrs (old: {
    mesonBuildType = "release";
    mesonFlags = old.mesonFlags ++ [ "-Db_lto=true" "-Db_lto_mode=thin" ];
    ninjaFlags = [ "--verbose" ];
  })).override { inherit llvmPackages stdenv; };
}
