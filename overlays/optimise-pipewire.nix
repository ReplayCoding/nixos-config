self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv genericOptions mesonOptions makeStatic;

  fdk_aac = (super.fdk_aac.override { stdenv = makeStatic stdenv; }).overrideAttrs (old: rec {
    makeFlags = (old.makeFlags or [ ]) ++ [ "V=1" ];
    configureFlags = (old.configureFlags or [ ]) ++ [ "--with-pic" ];
    CFLAGS = "-flto=thin -Ofast";
    CXXFLAGS = CFLAGS;
  } // genericOptions old);
in
{
  pipewire-optimised =
    (super.pipewire.override { inherit stdenv fdk_aac; }).overrideAttrs mesonOptions;
}
