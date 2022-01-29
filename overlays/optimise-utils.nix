super:

let
  llvmPackages = super.llvmPackages_13.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };
  ccNoCache = llvmPackages.clang.override {
    inherit (llvmPackages) bintools;
  };
  ccacheConfig = super.writeText "ccache-config" ''
    cache_dir = ${super.nixosPassthru.ccacheDir}
    umask = 002
    compiler_check = string:${ccNoCache}
    ignore_options = -frandom-seed=*
    max_size = 50G
  '';
  cc = (super.ccacheWrapper.override rec {
    cc = ccNoCache;
    extraConfig =
      ''
        export CCACHE_CONFIGPATH=${ccacheConfig}
        export CCACHE_BASEDIR=$NIX_BUILD_TOP
        [ -d "${super.nixosPassthru.ccacheDir}" ] || exec ${cc}/bin/$(basename "$0") "$@"
      '';
  }).overrideAttrs (old: {
    # https://github.com/NixOS/nixpkgs/issues/119779
    installPhase = builtins.replaceStrings [ "use_response_file_by_default=1" ] [ "use_response_file_by_default=0" ] old.installPhase;
  });
  stdenvNoCache = (super.overrideCC llvmPackages.stdenv ccNoCache);
  stdenv = (super.overrideCC llvmPackages.stdenv cc);
  makeStatic = s: super.propagateBuildInputs (super.makeStaticLibraries s);
  genericOptions = old: {
    hardeningDisable = [ "all" ];
  };
  mesonOptions = old: (genericOptions old) // {
    mesonBuildType = "release";
    mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Db_lto=true" "-Db_lto_mode=thin" ];
    ninjaFlags = [ "--verbose" ];
  };
in
{
  inherit
    stdenv
    stdenvNoCache
    llvmPackages
    genericOptions
    mesonOptions
    makeStatic;
  _ccacheConfig = ccacheConfig;
}
