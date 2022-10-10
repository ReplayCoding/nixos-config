{pkgs, ...}: {
  home.packages = with pkgs; [
    rizin
    ghidra
    python3
  ];
  xdg.dataFile."rizin" = {
    source = "${pkgs.rz-ghidra}/lib/rizin";
    recursive = true;
  };
}
