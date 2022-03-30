self: super: let
  inherit (import ./utils.nix super) stdenv makeStatic mesonOptions mesonOptions_pgo fakeExtra createWithBuildIdList getDrvName llvmPackages_version;
  sources = super.callPackage ../_sources/generated.nix {};
  mkOptimisedMesa = pgoMode': let
    inherit (super.stdenv) isi686;
    pgoMode =
      if isi686
      then "off"
      else pgoMode';
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
          llvmPackages = let
            llvmPackages = super."${llvmPackages_version}";
          in
            llvmPackages
            // (
              if isi686
              then rec {
                libllvm = llvmPackages.libllvm.override {inherit stdenv;};
                llvm = libllvm.out // {outputSpecified = false;};
              }
              else {}
            );
          wayland = wayland-optimised;
          libdrm = libdrm-optimised;
        }
        // super.nixosPassthru.mesaConfig
      );
  };
in
  createWithBuildIdList super mkOptimisedMesa
