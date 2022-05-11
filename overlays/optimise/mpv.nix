self: super: let
  inherit (import ./utils.nix super) stdenv autotoolsOptions_pgo mesonOptions_pgo makeStatic fakeExtra getDrvName createWithBuildIdList;
  sources = super.callPackage ../_sources/generated.nix {};
  pgoName = getDrvName self.mpv-unwrapped;

  mkOptimisedMpv = pgoMode: let
    dav1d =
      # This cannot be made into a static library, as lld crashes when linking with lto
      (super.dav1d.override {inherit stdenv;}).overrideAttrs (
        mesonOptions_pgo pgoName pgoMode "sample"
        (old: {inherit (sources.dav1d) src version;})
      );

    ffmpeg =
      # While ffmpeg is not using autotools, its build system
      # is close enough to be compatible with it.
      (super.ffmpeg-full.overrideAttrs (autotoolsOptions_pgo pgoName pgoMode "sample" (old: {
        configureFlags = builtins.filter (f: f != "--enable-shared") old.configureFlags;
        # Disable tests :O
        checkPhase = null;
        safeBitstreamReaderBuild = false;
      })))
      .override {
        stdenv = makeStatic stdenv;
        ffmpeg = super.ffmpeg_5;
        inherit dav1d;
        # Building these programs takes a looooong time
        ffmpegProgram = false;
        ffplayProgram = false;
        ffprobeProgram = false;
        qtFaststartProgram = false;
      };

    libass =
      (super.libass.override {stdenv = makeStatic stdenv;}).overrideAttrs (autotoolsOptions_pgo pgoName pgoMode "sample" fakeExtra);

    libplacebo = (super.libplacebo.override {stdenv = makeStatic stdenv;}).overrideAttrs (mesonOptions_pgo pgoName pgoMode "sample" (old: {
      inherit (sources.libplacebo) src version;

      mesonFlags = old.mesonFlags ++ ["-Dunwind=disabled"];
    }));
  in {
    mpv-unwrapped =
      (super.mpv-unwrapped.override {
        inherit stdenv ffmpeg libass libplacebo;
        lua = super.luajit;
      })
      .overrideAttrs (autotoolsOptions_pgo pgoName pgoMode "sample" (old: {
        inherit (sources.mpv) src version;
        wafFlags = (old.wafFlags or []) ++ ["--verbose"];
      }));
  };
in
  createWithBuildIdList super mkOptimisedMpv
