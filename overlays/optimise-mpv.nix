self: super:

let
  llvmPackages = super.llvmPackages_13.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };
  stdenv = super.impureUseNativeOptimizations (super.overrideCC llvmPackages.stdenv (llvmPackages.stdenv.cc.override {
    inherit (llvmPackages) bintools;
  }));
  makeStatic = s: super.propagateBuildInputs (super.makeStaticLibraries s);

  thinLtoConfFlags = [ "LDFLAGS=-flto=thin" "CFLAGS=-flto=thin" ];
  dav1d = (super.dav1d.override {
    # This cannot be made into a static library, as lld crashes when linking with lto
    stdenv = stdenv;
  }).overrideAttrs (old: {
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
  }).overrideAttrs (old: {
    hardeningDisable = [ "all" ];
    wafConfigureFlags = old.wafConfigureFlags ++ thinLtoConfFlags;
  });

in
{ inherit mpv-unwrapped; }
