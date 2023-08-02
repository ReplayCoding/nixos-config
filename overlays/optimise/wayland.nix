self: super: let
  inherit (import ./utils.nix super) stdenv stdenvNoCache mesonOptions_pgo fakeExtra makeStatic createWithBuildIdList getDrvName;

  pkgsToOptimise = [
    "sway-unwrapped"
    "swayidle"
    # I don't know if the PGO profile could contain sensitive info (passphrase), so i'm disabling it
    # "swaylock"
    "wob"
    "wlsunset"
    "mako"
    "fuzzel"
    "foot"
  ];
  mkWayland = wayland: pgoMode: name:
    (wayland.override {
      stdenv = makeStatic stdenv;
    })
    .overrideAttrs (mesonOptions_pgo (getDrvName self.${name}) pgoMode "instr" (_: {
      separateDebugInfo = false;
    }));
  mkOptimisedPackages = pgoMode:
    super.lib.genAttrs pkgsToOptimise (
      name:
        (super.${name}.overrideAttrs (mesonOptions_pgo (getDrvName self.${name}) pgoMode "instr" fakeExtra)).override (old:
          {
            stdenv =
              if name == "foot"
              then stdenvNoCache
              else stdenv;
            wayland = mkWayland old.wayland pgoMode name;
          }
          // (
            if name == "sway-unwrapped"
            then {
              wlroots = (old.wlroots.overrideAttrs (mesonOptions_pgo (getDrvName self.${name}) pgoMode "instr" fakeExtra)).override (old': {
                stdenv = makeStatic stdenv;
                wayland = mkWayland super.wayland pgoMode name;
              });
            }
            else {}
          ))
    );
in
  createWithBuildIdList super mkOptimisedPackages
