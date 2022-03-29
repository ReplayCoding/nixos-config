self: super: let
  inherit (import ./utils.nix super) stdenv makeStatic mesonOptions_pgo fakeExtra createWithBuildIdList getDrvName llvmPackages_version;
  sources = super.callPackage ../_sources/generated.nix {};
  mkOptimisedMesa = pgoMode: let
    wayland-optimised =
      (super.wayland.override {stdenv = makeStatic stdenv;})
      .overrideAttrs (mesonOptions_pgo (getDrvName self.mesa-optimised) pgoMode (_: {
        separateDebugInfo = false;
      }));
    libdrm-optimised =
      (super.libdrm.override {
        stdenv = makeStatic stdenv;
        # This breaks the build
        withValgrind = false;
      })
      .overrideAttrs (mesonOptions_pgo (getDrvName self.mesa-optimised) pgoMode fakeExtra);
  in {
    mesa-optimised =
      (super.mesa.overrideAttrs (mesonOptions_pgo (getDrvName self.mesa-optimised) pgoMode (_: {
        inherit (sources.mesa) pname version src;
      })))
      .override (
        {
          inherit stdenv;
          llvmPackages = super."${llvmPackages_version}";
          wayland = wayland-optimised;
          libdrm = libdrm-optimised;
        }
        // super.nixosPassthru.mesaConfig
      );
  };
in
  createWithBuildIdList super mkOptimisedMesa
