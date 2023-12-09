{pkgs, ...}: {
  home.packages = with pkgs; [
    # rizin
    ghidra
    python3
    imhex
    (renderdoc.override {waylandSupport = true;})
    blender
  ];
  # xdg.dataFile."rizin" = {
  #   source = "${pkgs.rz-ghidra}/lib/rizin";
  #   recursive = true;
  # };
}
