{pkgs, ...}: {
  wayland.windowManager.sway.config = {
    output = {
      "LVDS-1" = {
        resolution = "1366x768";
        pos = "0,0";
      };
      "VGA-1" = {
        mode = "1920x1080@60Hz";
        pos = "1366,0";
      };
    };
  };
}
