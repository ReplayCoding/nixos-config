{ pkgs }:

{
  foot = import ./foot.nix;
  git = import ./git.nix { inherit pkgs; };
  i3status-rust = import ./i3status-rust.nix;
  rtorrent = import ./rtorrent.nix;
  starship = import ./starship.nix;
  tmux = import ./tmux.nix;
}
