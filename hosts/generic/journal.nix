_:

{
  services.journald.extraConfig = ''
    MaxRetentionSec=1w
    SystemMaxFileSize=20M
  '';
}
