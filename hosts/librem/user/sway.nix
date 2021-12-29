{ pkgs, ... }:

{
  wayland.windowManager.sway.config = {
    input = {
      "2321:21128:HTIX5288:00_0911:5288_Touchpad" = {
        tap = "enabled";
      };
    };
  };
}
