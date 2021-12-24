self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv makeStatic;

  fdk_aac = (super.fdk_aac.override { stdenv = makeStatic stdenv; }).overrideAttrs (old: rec {
    makeFlags = (old.makeFlags or [ ]) ++ [ "V=1" ];
    CFLAGS = "-flto -Ofast";
    CXXFLAGS = CFLAGS;
  });
in
{
  pipewire-optimised = (super.pipewire.override { inherit stdenv fdk_aac; }).overrideAttrs (old: {
    mesonBuildType = "release";
    mesonFlags = old.mesonFlags ++ [ "-Db_lto=true" ];
    ninjaFlags = [ "--verbose" ];
  });
}
