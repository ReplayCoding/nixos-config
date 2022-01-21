self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv genericOptions makeStatic;
in
{
  libarchive-optimised =
    let
      flags = "-flto=thin -O3";
    in
    (super.libarchive.overrideAttrs (old: rec {
      CFLAGS = (old.CFLAGS or "") + flags;
      LDFLAGS = (old.LDFLAGS or "") + flags;
      makeFlags = (old.makeFlags or [ ]) ++ [ "V=1" ];
    } // genericOptions old)).override { inherit stdenv; };
}
