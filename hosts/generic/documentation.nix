{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [man-pages nixpkgs-manual];
  documentation = {
    dev.enable = true;
    man.enable = true;
    info.enable = lib.mkForce false;
  };
}
