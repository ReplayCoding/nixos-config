self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv autotoolsOptions genericOptions mesonOptions makeStatic fakeExtra;
  sources = super.callPackage ./_sources/generated.nix { };

  dav1d =
    # This cannot be made into a static library, as lld crashes when linking with lto
    (super.dav1d.override { inherit stdenv; }).overrideAttrs (mesonOptions
      (old: { inherit (sources.dav1d) src version; })
    );

  ffmpeg =
    # While ffmpeg is not using autotools, its build system
    # is close enough to be compatible with it.
    (super.ffmpeg-full.overrideAttrs (autotoolsOptions (old: {
      configureFlags = builtins.filter (f: f != "--enable-shared") old.configureFlags;
      # Disable tests :O
      checkPhase = null;
      safeBitstreamReaderBuild = false;
      postFixup = super.lib.optionalString stdenv.isLinux ''
        addOpenGLRunpath $out/lib/libavcodec.a
        addOpenGLRunpath $out/lib/libavutil.a
      '';
    }))).override {
      stdenv = makeStatic stdenv;
      inherit dav1d;
      # Building these programs takes a looooong time
      ffmpegProgram = false;
      ffplayProgram = false;
      ffprobeProgram = false;
      qtFaststartProgram = false;
    };

  libass =
    (super.libass.override { stdenv = makeStatic stdenv; }).overrideAttrs (autotoolsOptions fakeExtra);

  libplacebo =
    (super.libplacebo.override { stdenv = makeStatic stdenv; }).overrideAttrs (mesonOptions (old: {
      inherit (sources.libplacebo) src version;

      mesonFlags = old.mesonFlags ++ [ "-Dunwind=disabled" ];
    }));

  mpv-unwrapped =
    (super.mpv-unwrapped.override {
      inherit stdenv ffmpeg libass libplacebo;
      lua = super.luajit;
    }).overrideAttrs (autotoolsOptions (old: {
      inherit (sources.mpv) src version;
      wafFlags = (old.wafFlags or [ ]) ++ [ "--verbose" ];
    }));
in
{ inherit mpv-unwrapped; }
