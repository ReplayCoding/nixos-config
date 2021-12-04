{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint gutenprintBin ];
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
}
