{ config, pkgs, ... }:

let
  colors = config.colorscheme.colors;
in
{
  programs.zathura = {
    enable = true;
    options = {
      recolor = true;

      default-bg = "#${colors.base00}";
      default-fg = "#${colors.base01}";

      statusbar-fg = "#${colors.base04}";
      statusbar-bg = "#${colors.base02}";

      inputbar-bg = "#${colors.base00}";
      inputbar-fg = "#${colors.base07}";

      notification-bg = "#${colors.base00}";
      notification-fg = "#${colors.base07}";

      notification-error-bg = "#${colors.base00}";
      notification-error-fg = "#${colors.base08}";

      notification-warning-bg = "#${colors.base00}";
      notification-warning-fg = "#${colors.base08}";

      highlight-color = "#${colors.base0A}";
      highlight-active-color = "#${colors.base0D}";

      completion-bg = "#${colors.base01}";
      completion-fg = "#${colors.base0D}";

      completion-highlight-fg = "#${colors.base07}";
      completion-highlight-bg = "#${colors.base0D}";

      recolor-lightcolor = "#${colors.base00}";
      recolor-darkcolor = "#${colors.base06}";
    };
  };
  xdg.mimeApps.defaultApplications = {
    "application/vnd.comicbook-rar" = "org.pwmt.zathura.desktop";
    "application/vnd.comicbook+zip" = "org.pwmt.zathura.desktop";
    "application/x-cb7" = "org.pwmt.zathura.desktop";
    "application/x-cbr" = "org.pwmt.zathura.desktop";
    "application/x-cbt" = "org.pwmt.zathura.desktop";
    "application/x-cbz" = "org.pwmt.zathura.desktop";
    "application/x-ext-cb7" = "org.pwmt.zathura.desktop";
    "application/x-ext-cbr" = "org.pwmt.zathura.desktop";
    "application/x-ext-cbt" = "org.pwmt.zathura.desktop";
    "application/x-ext-cbz" = "org.pwmt.zathura.desktop";
    "application/x-ext-djv" = "org.pwmt.zathura.desktop";
    "application/x-ext-djvu" = "org.pwmt.zathura.desktop";
    "image/vnd.djvu+multipage" = "org.pwmt.zathura.desktop";
    "application/x-bzdvi" = "org.pwmt.zathura.desktop";
    "application/x-dvi" = "org.pwmt.zathura.desktop";
    "application/x-ext-dvi" = "org.pwmt.zathura.desktop";
    "application/x-gzdvi" = "org.pwmt.zathura.desktop";
    "application/pdf" = "org.pwmt.zathura.desktop";
    "application/x-bzpdf" = "org.pwmt.zathura.desktop";
    "application/x-ext-pdf" = "org.pwmt.zathura.desktop";
    "application/x-gzpdf" = "org.pwmt.zathura.desktop";
    "application/x-xzpdf" = "org.pwmt.zathura.desktop";
    "application/postscript" = "org.pwmt.zathura.desktop";
    "application/x-bzpostscript" = "org.pwmt.zathura.desktop";
    "application/x-gzpostscript" = "org.pwmt.zathura.desktop";
    "application/x-ext-eps" = "org.pwmt.zathura.desktop";
    "application/x-ext-ps" = "org.pwmt.zathura.desktop";
    "image/x-bzeps" = "org.pwmt.zathura.desktop";
    "image/x-eps" = "org.pwmt.zathura.desktop";
    "image/x-gzeps" = "org.pwmt.zathura.desktop";
    "image/tiff" = "org.pwmt.zathura.desktop";
    "application/oxps" = "org.pwmt.zathura.desktop";
    "application/vnd.ms-xpsdocument" = "org.pwmt.zathura.desktop";
    "application/illustrator" = "org.pwmt.zathura.desktop";
  };
}
