{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [man-pages nixpkgs-manual.${pkgs.stdenv.system}];
  documentation = {
    dev.enable = true;
    man.enable = true;
    info.enable = lib.mkForce false;
  };
}
