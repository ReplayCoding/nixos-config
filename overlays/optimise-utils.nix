super:

let
  llvmPackages = super.llvmPackages_14.override {
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

  stdenvNoCache = super.overrideCC llvmPackages.stdenv ccNoCache;
  stdenv = super.overrideCC llvmPackages.stdenv (mkCCacheWrapper ccNoCache);
  makeStatic = s: super.propagateBuildInputs (super.makeStaticLibraries s);

  fakeExtra = _: { };
  mkOptions =
    { old, layers }:
    builtins.foldl'
      (prevLayer: curLayer: prevLayer // (curLayer (old // prevLayer)))
      { }
      layers;
  genericOptions =
    extra: old':
    mkOptions {
      old = old';
      layers = [
        extra
        (
          old:
          { hardeningDisable = [ "all" ]; }
          // (
            if (super.nixosPassthru ? arch)
            then {
              NIX_CFLAGS_COMPILE =
                toString (old.NIX_CFLAGS_COMPILE or "") + " -march=${super.nixosPassthru.arch}"; # host platform
              NIX_CFLAGS_COMPILE_FOR_TARGET =
                toString (old.NIX_CFLAGS_COMPILE_FOR_TARGET or "") + " -march=${super.nixosPassthru.arch}";
            }
            else { }
          )
        )
      ];
    };
  autotoolsOptions =
    extra: old':
    mkOptions {
      old = old';
      layers = [
        extra
        (genericOptions fakeExtra)
        (
          old:
          let
            flags = " -flto=thin -O3";
          in
          {
            CFLAGS = (old.CFLAGS or "") + flags;
            CXXFLAGS = (old.CXXFLAGS or "") + flags;
            LDFLAGS = (old.LDFLAGS or "") + flags;
            makeFlags = (old.makeFlags or [ ]) ++ [ "V=1" ];
          }
        )
      ];
    };
  mesonOptions =
    extra: old':
    mkOptions {
      old = old';
      layers = [
        extra
        (genericOptions fakeExtra)
        (
          old:
          {
            mesonBuildType = "release";
            mesonFlags = (old.mesonFlags or [ ]) ++ [
              "-Db_lto=true"
              "-Db_lto_mode=thin"
            ];
            ninjaFlags = (old.ninjaFlags or [ ]) ++ [ "--verbose" ];
          }
        )
      ];
    };

  fixProfile =
    profile:
    super.runCommand "fix-profile-${profile}" { }
      ''${llvmPackages.libllvm}/bin/llvm-profdata merge --binary --output $out "${profile}"'';
  getProfilePath = name: (./pgo + "/${name}-${super.nixosPassthru.hostname}.profdata");
  getDrvName =
    old:
    let
      pname_version = "${old.pname}-${old.version}";
    in
    if (builtins.hasAttr "name" old) then old.name else pname_version;
  fixPgoMode =
    name: pgoMode: pgoProfile:
    if ((pgoMode != "use") || (builtins.pathExists pgoProfile))
    then pgoMode
    else builtins.trace "Package ${name} has no PGO profile (${toString pgoProfile}), disabling" "off";

  mesonOptions_pgo =
    name: pgoMode: extra: old':
    let
      name' = if name != null then name else getDrvName old';
      pgoProfile = getProfilePath name';
      pgoMode' = fixPgoMode name' pgoMode pgoProfile;
    in
    mkOptions {
      old = old';
      layers = [
        extra
        (mesonOptions fakeExtra)
        (
          old: {
            PGO_PROFILE_NAME = name';
            mesonFlags = (old.mesonFlags or [ ]) ++ [
              "-Db_pgo=${pgoMode'}"
              "-Dwerror=false" # Fix for PGO
              "-Dc_args=-Wno-ignored-optimization-argument"
              "-Dcpp_args=-Wno-ignored-optimization-argument"
              "-Dc_link_args=-Wl\\,--build-id=sha1"
              "-Dcpp_link_args=-Wl\\,--build-id=sha1"
            ];
            postConfigure =
              (
                if pgoMode' == "use"
                then
                  ''
                    cp ${fixProfile pgoProfile} ./default.profdata
                  ''
                else ""
              ) + (old.postConfigure or "");
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ ./pgo-hook.sh ];
          }
        )
      ];
    };
  autotoolsOptions_pgo =
    name: pgoMode: extra: old':
    mkOptions {
      old = old';
      layers = [
        extra
        (autotoolsOptions fakeExtra)
        (
          old:
          let
            name' = if name != null then name else getDrvName old';
            pgoProfile = getProfilePath name';
            pgoMode' = fixPgoMode name' pgoMode pgoProfile;
            flags =
              if pgoMode' == "use"
              then " -fprofile-use=${fixProfile pgoProfile}"
              else
                if pgoMode' == "off"
                then ""
                else " -fprofile-${pgoMode'}";
          in
          {
            PGO_PROFILE_NAME = name';
            CFLAGS = (old.CFLAGS or "") + flags;
            CXXFLAGS = (old.CXXFLAGS or "") + flags;
            LDFLAGS = (old.LDFLAGS or "") + flags;
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ ./pgo-hook.sh ];
          }
        )
      ];
    };
  createWithBuildIdList =
    super': mkEpkgs:
    {
      pkgsToExtractBuildId =
        super'.pkgsToExtractBuildId
        ++ (builtins.attrValues (mkEpkgs "generate"));
    } // mkEpkgs super.nixosPassthru.pgoMode;
in
{
  inherit
    mkCCacheWrapper
    stdenv
    stdenvNoCache
    llvmPackages
    fakeExtra
    genericOptions
    autotoolsOptions
    mesonOptions
    mesonOptions_pgo
    autotoolsOptions_pgo
    getDrvName
    makeStatic
    createWithBuildIdList;
}
