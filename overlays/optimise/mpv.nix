self: super: let
  inherit (import ./utils.nix super) stdenv autotoolsOptions_pgo mesonOptions_pgo makeStatic fakeExtra getDrvName createWithBuildIdList;
  pgoName = getDrvName self.mpv-unwrapped;

  mkOptimisedMpv = pgoMode: let
    dav1d =
      # This cannot be made into a static library, as lld crashes when linking with lto
      (super.dav1d.override {inherit stdenv;}).overrideAttrs (
        mesonOptions_pgo pgoName pgoMode "sample"
        (old: {inherit (super.mkOverridesFromFlakeInput "dav1d") src version;})
      );

    ffmpeg =
      # While ffmpeg is not using autotools, its build system
      # is close enough to be compatible with it.
      (super.ffmpeg-full.overrideAttrs (autotoolsOptions_pgo pgoName pgoMode "sample" (old: {
        checkPhase = null;
        safeBitstreamReaderBuild = false;
      })))
      .override {
        inherit stdenv;
        ffmpeg = super.ffmpeg_5;
        vid-stab = null;
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
      inherit (super.mkOverridesFromFlakeInput "libplacebo") src version;

      mesonFlags = old.mesonFlags ++ ["-Dunwind=disabled"];
    }));
  in {
    mpv-unwrapped =
      (super.mpv-unwrapped.override {
        inherit
          stdenv
          libass
          # libplacebo FIXME
          ;

        ffmpeg_5 = ffmpeg;
        lua = super.luajit;
      })
      .overrideAttrs (mesonOptions_pgo pgoName pgoMode "sample" (old: {
        inherit (super.mkOverridesFromFlakeInput "mpv") src version;
      }));
  };
in
  createWithBuildIdList super mkOptimisedMpv
