{
  config,
  pkgs,
  lib,
  ...
}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
      jetbrains-mono
      corefonts
      nerd-fonts.jetbrains-mono
    ];
    fontconfig.defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      emoji = ["Noto Color Emoji"];
      monospace = ["JetBrains Mono NL" "Noto Sans Mono CJK JP"];
    };
  };
}
