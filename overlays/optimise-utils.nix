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

  fakeExtra = (_: { });
  mkOptions =
    { old_, options, extra, _extra ? fakeExtra }:
    let
      beforeExtra = old_ // (options old_);
      _beforeExtra = beforeExtra // (extra beforeExtra);
    in
    (options old_) // (extra beforeExtra) // (_extra _beforeExtra);
  genericOptions =
    extra: old':
    mkOptions {
      inherit extra;
      old_ = old';
      options = old:
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
        );
    };
  autotoolsOptions =
    extra: old':
    mkOptions {
      inherit extra;
      _extra = genericOptions fakeExtra;
      old_ = old';
      options = old:
        let
          flags = " -flto=thin -O3";
        in
        {
          CFLAGS = (old.CFLAGS or "") + flags;
          CXXFLAGS = (old.CXXFLAGS or "") + flags;
          LDFLAGS = (old.LDFLAGS or "") + flags;
          makeFlags = (old.makeFlags or [ ]) ++ [ "V=1" ];
        };
    };
  mesonOptions =
    extra: old':
    mkOptions {
      inherit extra;
      _extra = genericOptions fakeExtra;
      old_ = old';
      options = old: {
        mesonBuildType = "release";
        mesonFlags = (old.mesonFlags or [ ]) ++ [
          "-Db_lto=true"
          "-Db_lto_mode=thin"
        ];
        ninjaFlags = (old.ninjaFlags or [ ]) ++ [ "--verbose" ];
      };
    };

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
      inherit extra;
      _extra = mesonOptions fakeExtra;
      old_ = old';
      options = old: {
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
                cp ${pgoProfile} ./default.profdata
              ''
            else ""
          ) + (old.postConfigure or "");
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ ./pgo-hook.sh ];
      };
    };
  autotoolsOptions_pgo =
    name: pgoMode: extra: old':
    mkOptions {
      inherit extra;
      _extra = autotoolsOptions fakeExtra;
      old_ = old';
      options = old:
        let
          name' = if name != null then name else getDrvName old';
          pgoProfile = getProfilePath name';
          pgoMode' = fixPgoMode name' pgoMode pgoProfile;
          flags =
            if pgoMode' == "use"
            then " -fprofile-use=${pgoProfile}"
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
        };
    };
  createWithBuildIdList =
    super': mkEpkgs:
    {
      pkgsToExtractBuildId =
        super'.pkgsToExtractBuildId
        ++ (builtins.attrValues (mkEpkgs { pgoMode = "generate"; }));
    } // mkEpkgs { };
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
