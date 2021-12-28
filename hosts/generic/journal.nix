{ ... }:

{
  services.journald.extraConfig = ''
    MaxRetentionSec=2d
    SystemMaxFileSize=20M
  '';
}
