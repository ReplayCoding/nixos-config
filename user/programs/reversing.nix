{pkgs, ...}: {
  home.packages = with pkgs; [
    rizin
    ghidra
  ];
  xdg.dataFile."rizin" = {
    source = "${pkgs.rz-ghidra}/share/rizin";
    recursive = true;
  };
}
