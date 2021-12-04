{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -sd -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet -c \"systemd-cat sway\"";
      };
    };
  };
}
