{ pkgs, ... }:

{
  home.packages = with pkgs; [ rizin ];
  xdg.dataFile."rizin" = {
    source = "${pkgs.rz-ghidra}/share/rizin";
    recursive = true;
  };
}
