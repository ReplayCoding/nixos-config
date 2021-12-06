{ pkgs, config, ... }:

{
  services.greetd = {
    enable = true;
    settings =
      let cmd = "systemd-cat sway";
      in
      {
        default_session = {
          command = "${pkgs.cage}/bin/cage -sd -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet -c \"${cmd}\"";
        };
        initial_session = {
          user = "${config.users.users.user.name}";
          command = "${cmd}";
        };
      };
  };
}
