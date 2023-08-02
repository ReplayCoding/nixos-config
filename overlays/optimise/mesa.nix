self: super: let
  inherit (import ./utils.nix super) createWithBuildIdList;
  mkOptimisedMesaWithArch = super': pgoMode: let
    inherit (import ./utils.nix super') stdenv makeStatic mesonOptions mesonOptions_pgo fakeExtra getDrvName;
    inherit (super'.stdenv.hostPlatform) isi686;
    pgoType =
      if isi686
      then "sample"
      else "instr";
    wayland-optimised =
      (super'.wayland.override {stdenv = makeStatic stdenv;})
      .overrideAttrs (mesonOptions_pgo (getDrvName mesa-optimised) pgoMode pgoType (_: {
        separateDebugInfo = false;
      }));
    libdrm-optimised =
      (super'.libdrm.override {
        # Static builds cause a symbol conflict with mesa
        inherit stdenv;
        # This breaks the build
        withValgrind = false;
      })
      .overrideAttrs (mesonOptions_pgo (getDrvName mesa-optimised) pgoMode pgoType (old: {
        mesonFlags = (old.mesonFlags or []) ++ ["-Dvalgrind=disabled"];
      }));
    vulkan-loader =
      (super'.vulkan-loader.overrideAttrs (old: {
        cmakeBuildType = "plain";
        cmakeFlags =
          old.cmakeFlags
          ++ ["-DCMAKE_VERBOSE_MAKEFILE=ON"]
          ++ (super'.lib.optionals (super'.stdenv.hostPlatform != super'.stdenv.buildPlatform) ["-DUSE_GAS=OFF"]);
      }))
      .override {inherit stdenv;};
    mesa-optimised =
      (super'.mesa.overrideAttrs (mesonOptions_pgo (getDrvName mesa-optimised) pgoMode pgoType (old: {
        buildInputs = old.buildInputs ++ [vulkan-loader];
      })))
      .override (
        {
          inherit stdenv;
          # llvmPackages = super'."${llvmPackages_version}";
          wayland = wayland-optimised;
          libdrm = libdrm-optimised;
        }
        // super'.nixosPassthru.mesaConfig
      );
  in
    mesa-optimised;
  mkOptimisedMesa = pgoMode: {
    mesa-optimised = mkOptimisedMesaWithArch super pgoMode;
    mesa-optimised-32 = mkOptimisedMesaWithArch super.pkgsCross.gnu32 pgoMode;
  };
in
  createWithBuildIdList super mkOptimisedMesa
