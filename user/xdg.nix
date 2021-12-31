{ config, lib, pkgs, ... }:

{
  xdg = {
    enable = true;
    mimeApps.enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
