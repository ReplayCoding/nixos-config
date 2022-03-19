{pkgs, ...}: {
  home.packages = [pkgs.cmus];
  xdg.configFile."cmus/rc".text = ''
    set repeat=true
    set repeat_current=true
    set shuffle=true
    set replaygain=track-preferred
  '';
}
