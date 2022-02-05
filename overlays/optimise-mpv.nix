self: super:

let
  inherit (import ./optimise-utils.nix super) stdenv genericOptions mesonOptions makeStatic;
  sources = super.callPackage ./_sources/generated.nix { };

  thinLtoConfFlags = [ "LDFLAGS=-flto=thin" "CFLAGS=-flto=thin" ];

  dav1d =
    # This cannot be made into a static library, as lld crashes when linking with lto
    (super.dav1d.override { inherit stdenv; }).overrideAttrs (
      old: { inherit (sources.dav1d) src version; }
        // mesonOptions old
    );

  ffmpeg =
    (super.ffmpeg-full.overrideAttrs (old: {
      configureFlags = (builtins.filter (f: f != "--enable-shared") old.configureFlags) ++ [ "--extra-cflags=-flto=thin" ];
      makeFlags = [ "V=1" ];
      # Disable tests :O
      checkPhase = null;
      safeBitstreamReaderBuild = false;
      postFixup = super.lib.optionalString stdenv.isLinux ''
        addOpenGLRunpath $out/lib/libavcodec.a
        addOpenGLRunpath $out/lib/libavutil.a
      '';
    } // genericOptions old)).override {
      stdenv = makeStatic stdenv;
      inherit dav1d;
      # Building these programs takes a looooong time
      ffmpegProgram = false;
      ffplayProgram = false;
      ffprobeProgram = false;
      qtFaststartProgram = false;
    };

  libass =
    (super.libass.override { stdenv = makeStatic stdenv; }).overrideAttrs (old: {
      configureFlags = old.configureFlags ++ thinLtoConfFlags;
    } // genericOptions old);

  libplacebo =
    (super.libplacebo.override { stdenv = makeStatic stdenv; }).overrideAttrs (old: (mesonOptions old) // {
      inherit (sources.libplacebo) src version;

      mesonFlags = old.mesonFlags ++ [ "-Db_lto=true" "-Db_lto_mode=thin" "-Dunwind=disabled" ];
    });

  mpv-unwrapped =
    (super.mpv-unwrapped.override {
      inherit stdenv ffmpeg libass libplacebo;
      lua = super.luajit;
    }).overrideAttrs (old: {
      inherit (sources.mpv) src version;

      wafConfigureFlags = old.wafConfigureFlags ++ thinLtoConfFlags;
    } // genericOptions old);
in
{ inherit mpv-unwrapped; }
