super: let
  llvmPackages_version = "llvmPackages_14";
  llvmPackages = super.buildPackages."${llvmPackages_version}".override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };
  llvmPackages_host = super."${llvmPackages_version}".override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };

  ccNoCache = llvmPackages.clang.override {
    inherit (llvmPackages) bintools;
  };

  mkCCacheWrapper = ccToWrap: let
    ccacheConfig = super.writeText "ccache-config" ''
      cache_dir = ${super.nixosPassthru.ccacheDir}
      umask = 002
      compiler_check = string:${ccToWrap}
      ignore_options = -frandom-seed=*
      max_size = 10G
    '';
  in
    (super.pkgsBuildBuild.ccacheWrapper.override rec {
      cc = ccToWrap;
      extraConfig = ''
        export CCACHE_CONFIGPATH=${ccacheConfig}
        export CCACHE_BASEDIR=$NIX_BUILD_TOP
        [ -d "${super.nixosPassthru.ccacheDir}" ] || exec ${cc}/bin/$(basename "$0") "$@"
      '';
    })
    .overrideAttrs (old: {
      # https://github.com/NixOS/nixpkgs/issues/119779
      installPhase = builtins.replaceStrings ["use_response_file_by_default=1"] ["use_response_file_by_default=0"] old.installPhase;
      passthru = old.passthru // {inherit ccacheConfig;};
    });

  stdenvNoCache = super.overrideCC llvmPackages_host.stdenv ccNoCache;
  stdenv = super.overrideCC llvmPackages_host.stdenv (mkCCacheWrapper ccNoCache);
  makeStatic = s: super.propagateBuildInputs (super.makeStaticLibraries s);

  fakeExtra = _: {};
  mkOptions = {
    old,
    layers,
  }:
    builtins.foldl'
    (prevLayer: curLayer: prevLayer // (curLayer (old // prevLayer)))
    {}
    (super.lib.flatten layers);
  genericOptions = extra: old':
    mkOptions {
      old = old';
      layers = [
        (old: {hardeningDisable = ["all"];})
        (
          old:
            if (super.nixosPassthru ? arch)
            then {
              NIX_CFLAGS_COMPILE =
                toString (old.NIX_CFLAGS_COMPILE or "") + " -march=${super.nixosPassthru.arch}"; # host platform
              NIX_CFLAGS_COMPILE_FOR_TARGET =
                toString (old.NIX_CFLAGS_COMPILE_FOR_TARGET or "") + " -march=${super.nixosPassthru.arch}";
            }
            else {}
        )
        extra
      ];
    };
  autotoolsOptions = extra: old':
    mkOptions {
      old = old';
      layers = [
        (genericOptions fakeExtra)
        (
          old: let
            flags = " -flto=thin -O3";
          in {
            CFLAGS = (toString old.CFLAGS or "") + flags;
            CXXFLAGS = (toString old.CXXFLAGS or "") + flags;
            LDFLAGS = (toString old.LDFLAGS or "") + flags;
            makeFlags = (old.makeFlags or []) ++ ["V=1"];
          }
        )
        extra
      ];
    };
  mesonOptions = extra: old':
    mkOptions {
      old = old';
      layers = [
        (genericOptions fakeExtra)
        (
          old: {
            mesonBuildType = "release";
            mesonFlags =
              (old.mesonFlags or [])
              ++ [
                "-Db_lto=true"
                "-Db_lto_mode=thin"
              ];
            ninjaFlags = (old.ninjaFlags or []) ++ ["--verbose"];
          }
        )
        extra
      ];
    };

  fixProfile = profile: pgoType:
    super.runCommand "fix-profile-${profile}" {}
    ''${llvmPackages.libllvm}/bin/llvm-profdata merge --${pgoType} --binary --output $out "${profile}"'';
  getProfilePath = name: (./pgo + "/${super.nixosPassthru.hostname}-${name}.profdata");
  getDrvName = old:
    if (builtins.hasAttr "pname" old)
    then "${old.pname}-${old.version}-${old.stdenv.hostPlatform.system}"
    else "${old.name}-${old.system}";
  fixPgoMode = name: pgoMode: pgoType: pgoProfile:
    if ((pgoMode == "use") && !(builtins.pathExists pgoProfile))
    then builtins.trace "Package ${name} has no PGO profile (${toString pgoProfile}), disabling" "off"
    else if (pgoType == "sample" && pgoMode == "generate")
    then "off"
    else pgoMode;
  generatePgoSupportData = name: pgoType:
    builtins.toJSON {
      inherit name;
      type = pgoType;
    };

  mesonOptions_pgo = name: pgoMode: pgoType: extra: old': let
    pgoProfile = getProfilePath name;
    pgoMode' = fixPgoMode name pgoMode pgoType pgoProfile;
  in
    mkOptions {
      old = old';
      layers = [
        (mesonOptions fakeExtra)
        (
          old: {
            PGO_SUPPORT_DATA = generatePgoSupportData name pgoType;
            NIX_CFLAGS_COMPILE =
              if pgoType == "sample"
              then (toString old.NIX_CFLAGS_COMPILE or "") + " -fno-profile-instr-use -fprofile-sample-use"
              else old.NIX_CFLAGS_COMPILE;
            mesonFlags =
              (old.mesonFlags or [])
              ++ [
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
                then ''
                  cp ${fixProfile pgoProfile pgoType} ./default.profdata
                ''
                else ""
              )
              + (old.postConfigure or "");
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [./pgo/pgo-hook.sh];
          }
        )
        (old:
          if super.stdenv.isi686
          then {
            # Allow using perf for 32-bit mesa
            dontStrip = true;
            separateDebugInfo = false;
            mesonFlags = old.mesonFlags ++ ["-Ddebug=true"];
          }
          else {})
        extra
      ];
    };
  autotoolsOptions_pgo = name: pgoMode: pgoType: extra: old':
    mkOptions {
      old = old';
      layers = [
        (autotoolsOptions fakeExtra)
        (
          old: let
            pgoProfile = getProfilePath name;
            pgoMode' = fixPgoMode name pgoMode pgoType pgoProfile;
            pgoFlags =
              if pgoMode' == "use"
              then " -fprofile-${pgoType}-use=${fixProfile pgoProfile pgoType}"
              else if pgoMode' == "off"
              then ""
              else " -fprofile-${pgoMode'}";
          in {
            PGO_SUPPORT_DATA = generatePgoSupportData name pgoType;
            CFLAGS = (toString old.CFLAGS or "") + pgoFlags + " -Wno-ignored-optimization-argument";
            CXXFLAGS = (toString old.CXXFLAGS or "") + pgoFlags + " -Wno-ignored-optimization-argument";
            LDFLAGS = (toString old.LDFLAGS or "") + pgoFlags + " -Wl,--build-id=sha1";
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [./pgo/pgo-hook.sh];
          }
        )
        extra
      ];
    };
  createWithBuildIdList = super': mkEpkgs:
    {
      pkgsToExtractBuildId =
        super'.pkgsToExtractBuildId
        ++ (builtins.attrValues (mkEpkgs "generate"));
    }
    // mkEpkgs super.nixosPassthru.pgoMode;
in {
  inherit
    mkCCacheWrapper
    stdenv
    stdenvNoCache
    llvmPackages
    llvmPackages_version
    fakeExtra
    genericOptions
    autotoolsOptions
    mesonOptions
    mesonOptions_pgo
    autotoolsOptions_pgo
    getDrvName
    makeStatic
    createWithBuildIdList
    ;
}
