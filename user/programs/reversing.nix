{pkgs, ...}: {
  home.packages = with pkgs; [
    # rizin
    ghidra
    python3
    imhex
  ];
  # xdg.dataFile."rizin" = {
  #   source = "${pkgs.rz-ghidra}/lib/rizin";
  #   recursive = true;
  # };
}
