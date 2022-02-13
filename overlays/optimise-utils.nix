super:

let
  llvmPackages = super.llvmPackages_13.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };
  ccNoCache = llvmPackages.clang.override {
    inherit (llvmPackages) bintools;
  };

  mkCCacheWrapper = ccToWrap:
    let
      ccacheConfig = super.writeText "ccache-config" ''
        cache_dir = ${super.nixosPassthru.ccacheDir}
        umask = 002
        compiler_check = string:${ccToWrap}
        ignore_options = -frandom-seed=*
        max_size = 10G
      '';
    in
    (super.ccacheWrapper.override rec {
      cc = ccToWrap;
      extraConfig =
        ''
          export CCACHE_CONFIGPATH=${ccacheConfig}
          export CCACHE_BASEDIR=$NIX_BUILD_TOP
          [ -d "${super.nixosPassthru.ccacheDir}" ] || exec ${cc}/bin/$(basename "$0") "$@"
        '';
    }).overrideAttrs (old: {
      # https://github.com/NixOS/nixpkgs/issues/119779
      installPhase = builtins.replaceStrings [ "use_response_file_by_default=1" ] [ "use_response_file_by_default=0" ] old.installPhase;
      passthru = old.passthru // { inherit ccacheConfig; };
    });

  stdenvNoCache = (super.overrideCC llvmPackages.stdenv ccNoCache);
  stdenv = (super.overrideCC llvmPackages.stdenv (mkCCacheWrapper ccNoCache));
  makeStatic = s: super.propagateBuildInputs (super.makeStaticLibraries s);
  genericOptions =
    old:
    { hardeningDisable = [ "all" ]; }
    // (
      if (super.nixosPassthru ? arch) && (stdenv.hostPlatform == stdenv.buildPlatform)
      then { NIX_CFLAGS_COMPILE = toString (old.NIX_CFLAGS_COMPILE or "") + " -march=${super.nixosPassthru.arch}"; }
      else { }
    );
  autotoolsOptions =
    let
      flags = "-flto=thin -O3";
    in
    old: (genericOptions old) // {
      CFLAGS = (old.CFLAGS or "") + flags;
      LDFLAGS = (old.LDFLAGS or "") + flags;
      makeFlags = (old.makeFlags or [ ]) ++ [ "V=1" ];
    };
  mesonOptions = old: (genericOptions old) // {
    mesonBuildType = "release";
    mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Db_lto=true" "-Db_lto_mode=thin" ];
    ninjaFlags = [ "--verbose" ];
  };
in
{
  inherit
    mkCCacheWrapper
    stdenv
    stdenvNoCache
    llvmPackages
    genericOptions
    autotoolsOptions
    mesonOptions
    makeStatic;
}
