_: {
  programs.mpv = {
    enable = true;
    config = {
      vo = "gpu-next";
      gpu-context = "wayland";
      hwdec = "auto-safe";
    };
  };
}
