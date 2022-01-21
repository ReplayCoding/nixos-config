self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv mesonOptions makeStatic;

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
    "cage"
  ];
in
super.lib.genAttrs pkgsToOptimise (name:
  (super.${name}.overrideAttrs mesonOptions).override (old: {
    stdenv =
      if name == "wlroots"
      then makeStatic stdenv
      else stdenv;
    wayland = (old.wayland.override {
      stdenv = makeStatic stdenv;
    }).overrideAttrs (old:
      (mesonOptions old)
      // { separateDebugInfo = false; }
    );
  })
)
