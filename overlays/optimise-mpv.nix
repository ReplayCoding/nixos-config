self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv makeStatic;

  thinLtoConfFlags = [ "LDFLAGS=-flto=thin" "CFLAGS=-flto=thin" ];
  dav1d = (super.dav1d.override {
    # This cannot be made into a static library, as lld crashes when linking with lto
    inherit stdenv;
  }).overrideAttrs (old: rec {
    version = "633c63ed51b54a14c0fc547255b97f0e657e054d";
    src = super.fetchFromGitLab {
      domain = "code.videolan.org";
      owner = "videolan";
      repo = old.pname;
      rev = version;
      sha256 = "sha256-P4bxFLWHvbNyyeR53j1FNohSU0ZgTRC1BxPQbCqaPeM=";
    };

    mesonBuildType = "release";
    mesonFlags = old.mesonFlags ++ [ "-Db_lto=true" ];
    ninjaFlags = [ "--verbose" ];
  });
  ffmpeg = (super.ffmpeg-full.overrideAttrs (old: {
    configureFlags = (builtins.filter (f: f != "--enable-shared") old.configureFlags) ++ [ "--extra-cflags=-flto=thin" ];
    hardeningDisable = [ "all" ];
    # Disable tests :O
    checkPhase = null;
    runtimeCpuDetectBuild = false;
    safeBitstreamReaderBuild = false;
    postFixup = super.lib.optionalString stdenv.isLinux ''
      addOpenGLRunpath $out/lib/libavcodec.a
      addOpenGLRunpath $out/lib/libavutil.a
    '';
  })).override {
    stdenv = makeStatic stdenv;
    inherit dav1d;
    # Building these programs takes a looooong time
    ffmpegProgram = false;
    ffplayProgram = false;
    ffprobeProgram = false;
    qtFaststartProgram = false;
  };
  libass = (super.libass.override {
    stdenv = makeStatic stdenv;
  }).overrideAttrs (old: {
    hardeningDisable = [ "all" ];
    configureFlags = old.configureFlags ++ thinLtoConfFlags;
  });
  mpv-unwrapped = (super.mpv-unwrapped.override {
    inherit stdenv ffmpeg libass;
    lua = super.luajit;
  }).overrideAttrs (old: {
    hardeningDisable = [ "all" ];
    wafConfigureFlags = old.wafConfigureFlags ++ thinLtoConfFlags;
  });

in
{ inherit mpv-unwrapped; }
