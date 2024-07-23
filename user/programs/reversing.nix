{pkgs, ...}: {
  home.packages = with pkgs; [
    # rizin
    ghidra
    python312
    imhex
    # (renderdoc.override {waylandSupport = true;})
    pahole
    llvmPackages.bintools
    spirv-cross
  ];
  # xdg.dataFile."rizin" = {
  #   source = "${pkgs.rz-ghidra}/lib/rizin";
  #   recursive = true;
  # };
}
