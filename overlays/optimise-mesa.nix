self: super: let
  inherit (import ./optimise-utils.nix super) stdenv makeStatic mesonOptions_pgo llvmPackages fakeExtra createWithBuildIdList getDrvName;
  mkOptimisedMesa = pgoMode: {
    libdrm-optimised =
      (super.libdrm.override {
        stdenv = makeStatic stdenv;
        # This breaks the build
        withValgrind = false;
      })
      .overrideAttrs (mesonOptions_pgo (getDrvName self.mesa-optimised) pgoMode fakeExtra);
    mesa-optimised =
      (super.mesa.overrideAttrs (mesonOptions_pgo null pgoMode fakeExtra)).override (
        {
          inherit llvmPackages stdenv;
          libdrm = self.libdrm-optimised;
        }
        // super.nixosPassthru.mesaConfig
      );
  };
in
  createWithBuildIdList super mkOptimisedMesa
