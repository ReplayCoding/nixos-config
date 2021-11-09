{ ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      vo = "gpu";
      gpu-context = "wayland";
      hwdec = "auto-safe";
    };
  };
}
