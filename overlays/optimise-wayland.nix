self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv makeStatic;

  pkgsToOptimise = [
    "sway-unwrapped"
    "swayidle"
    "swaylock"
    "wob"
    "wlsunset"
    "mako"
    "fuzzel"
    "wlroots"
    "foot"
  ];
in
super.lib.genAttrs pkgsToOptimise (name:
  (super.${name}.overrideAttrs (old: {
    hardeningDisable = [ "all" ];

    mesonBuildType = "release";
    mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Db_lto=true" ];
    ninjaFlags = [ "--verbose" ];
  })).override (old: {
    stdenv =
      if name == "wlroots"
      then makeStatic stdenv
      else stdenv;
    wayland = (old.wayland.override {
      stdenv = makeStatic stdenv;
    }).overrideAttrs (old: {
      ninjaFlags = [ "--verbose" ];
      mesonFlags = old.mesonFlags ++ [ "-Db_lto=true" ];
      mesonBuildType = "release";
      separateDebugInfo = false;
    });
  }))
