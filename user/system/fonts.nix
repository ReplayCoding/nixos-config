{
  config,
  pkgs,
  lib,
  ...
}: {
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
      font-awesome
      jetbrains-mono
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];
    fontconfig.defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      emoji = ["Noto Color Emoji"];
      monospace = ["JetBrains Mono NL" "Noto Sans Mono CJK JP"];
    };
  };
}
