{pkgs, ...}: {
  systemd.tmpfiles.rules = ["d ${pkgs.nixosPassthru.llvmProfdataDir} 0777 - - 2d"];
  environment = {
    sessionVariables.LLVM_PROFILE_FILE = "${pkgs.nixosPassthru.llvmProfdataDir}/%p-%h-%m.profraw";
    systemPackages = [pkgs.extract-pgo-data];
  };
}
