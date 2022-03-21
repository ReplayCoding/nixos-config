final: prev: let
  inherit (import ./optimise-utils.nix prev) mkCCacheWrapper;
  inherit (final) lib linuxKernel;
  inherit (lib.kernel) yes no;

  applyCfg = config: kernel:
    kernel.override {
      argsOverride.kernelPatches = kernel.kernelPatches;
      argsOverride.structuredExtraConfig = kernel.structuredExtraConfig // config;
    };

  applyLLVM = kernel: let
    llvmPackages = "llvmPackages_13";
    noBintools = {
      bootBintools = null;
      bootBintoolsNoLibc = null;
    };
    hostLLVM = final.pkgsBuildHost.${llvmPackages}.override noBintools;
    buildLLVM = final.pkgsBuildBuild.${llvmPackages}.override noBintools;

    mkLLVMPlatform = platform:
      platform
      // {
        useLLVM = true;
        linux-kernel =
          platform.linux-kernel
          // {
            makeFlags =
              (platform.linux-kernel.makeFlags or [])
              ++ [
                "LLVM=1"
                "LLVM_IAS=1"
                "KBUILD_VERBOSE=1"
                "CC=${mkCCacheWrapper buildLLVM.clangUseLLVM}/bin/clang"
                "LD=${buildLLVM.lld}/bin/ld.lld"
                "HOSTLD=${hostLLVM.lld}/bin/ld.lld"
                "AR=${buildLLVM.llvm}/bin/llvm-ar"
                "HOSTAR=${hostLLVM.llvm}/bin/llvm-ar"
                "NM=${buildLLVM.llvm}/bin/llvm-nm"
                "STRIP=${buildLLVM.llvm}/bin/llvm-strip"
                "OBJCOPY=${buildLLVM.llvm}/bin/llvm-objcopy"
                "OBJDUMP=${buildLLVM.llvm}/bin/llvm-objdump"
                "READELF=${buildLLVM.llvm}/bin/llvm-readelf"
                "HOSTCC=${mkCCacheWrapper hostLLVM.clangUseLLVM}/bin/clang"
                "HOSTCXX=${mkCCacheWrapper hostLLVM.clangUseLLVM}/bin/clang++"
              ];
          };
      };
    stdenvClangUseLLVM = final.overrideCC hostLLVM.stdenv (mkCCacheWrapper hostLLVM.clangUseLLVM);
    stdenvPlatformLLVM = stdenvClangUseLLVM.override (old: {
      hostPlatform = mkLLVMPlatform old.hostPlatform;
      buildPlatform = mkLLVMPlatform old.buildPlatform;
    });
    stdenv = stdenvPlatformLLVM;
  in
    kernel.override {
      inherit stdenv;
      buildPackages = final.buildPackages // {inherit stdenv;};
      argsOverride.kernelPatches =
        kernel.kernelPatches
        ++ [
          {
            name = "kernel-thinlto-readonly";
            patch = ./patches/kernel-thinlto-readonly.patch;
          }
        ];
      argsOverride.structuredExtraConfig = kernel.structuredExtraConfig;
    };

  applyLTO = kernel:
    applyCfg
    {
      LTO_NONE = no;
      LTO_CLANG_THIN = yes;
    }
    (applyLLVM kernel);

  inherit (linuxKernel) packagesFor;
in {
  myLinuxPackages-librem =
    (
      packagesFor
      (
        applyCfg
        {MSKYLAKE = yes;}
        (applyLTO linuxKernel.kernels.linux_xanmod)
      )
    )
    .extend (
      self: super: let
        callPackage = final.newScope super;
      in {librem-ec-acpi-dkms = callPackage ./librem-ec-acpi-dkms.nix {};}
    );
  myLinuxPackages-thinkpad =
    (
      packagesFor
      (
        applyCfg
        {MJAGUAR = yes;}
        (applyLTO linuxKernel.kernels.linux_xanmod)
      )
    )
    .extend (
      self: super: {
        broadcom_sta = super.broadcom_sta.overrideAttrs (old: {
          makeFlags = old.makeFlags ++ self.kernel.makeFlags;
        });
      }
    );
}
