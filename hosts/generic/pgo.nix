{ overlayConfig, pkgs, ... }:

let
  dir = "/var/cache/llvm-profdata";
in
(
  if (overlayConfig.pgoMode or "off") != "off"
  then
    {
      systemd.tmpfiles.rules = [ "d ${dir} 0777 - - -" ];
      environment = {
        sessionVariables.LLVM_PROFILE_FILE = "${dir}/%p-%h-%m.profraw";
        systemPackages = with pkgs; [ (extract-pgo-data.override { pgoDir = dir; }) ];
      };
    }
  else { }
)
