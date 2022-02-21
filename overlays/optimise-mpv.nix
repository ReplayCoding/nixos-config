self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv genericOptions mesonOptions makeStatic;
  sources = super.callPackage ./_sources/generated.nix { };

  thinLtoConfFlags = [ "LDFLAGS=-flto=thin" "CFLAGS=-flto=thin" ];

  dav1d =
    # This cannot be made into a static library, as lld crashes when linking with lto
    (super.dav1d.override { inherit stdenv; }).overrideAttrs (mesonOptions
      (old: { inherit (sources.dav1d) src version; })
    );

  ffmpeg =
    (super.ffmpeg-full.overrideAttrs (genericOptions (old: {
      configureFlags = (builtins.filter (f: f != "--enable-shared") old.configureFlags) ++ [ "--extra-cflags=-flto=thin" ];
      makeFlags = [ "V=1" ];
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
    (super.libass.override { stdenv = makeStatic stdenv; }).overrideAttrs (genericOptions (old: {
      configureFlags = old.configureFlags ++ thinLtoConfFlags;
    }));

  libplacebo =
    (super.libplacebo.override { stdenv = makeStatic stdenv; }).overrideAttrs (mesonOptions (old: {
      inherit (sources.libplacebo) src version;

      mesonFlags = old.mesonFlags ++ [ "-Dunwind=disabled" ];
    }));

  mpv-unwrapped =
    (super.mpv-unwrapped.override {
      inherit stdenv ffmpeg libass libplacebo;
      lua = super.luajit;
    }).overrideAttrs (genericOptions (old: {
      inherit (sources.mpv) src version;

      CFLAGS = (toString old.CFLAGS or "") + " -flto=thin";
      LDFLAGS = (toString old.LDFLAGS or "") + " -flto=thin";
    }));
in
{ inherit mpv-unwrapped; }
