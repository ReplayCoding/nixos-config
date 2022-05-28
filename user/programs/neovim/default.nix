{
  flib,
  pkgs,
  ...
}: {
  home.sessionVariables = rec {
    EDITOR = "nvim";
    VISUAL = EDITOR;
  };

  programs.neovim = {
    enable = true;
    extraConfig = "lua require('init')";
    extraPackages = let
      clangd = pkgs.clang-tools.override {llvmPackages = pkgs.llvmPackages_14;};
    in
      with pkgs; [
        pyright
        rnix-lsp
        rust-analyzer
        clangd
      ];
    plugins = let
      sources = flib.sources pkgs;
      spellsitter = pkgs.vimUtils.buildVimPlugin {
        # The plugin has a makefile which tries to run tests which try to pull neovim from git
        prePatch = ''
          rm Makefile
        '';
        inherit (sources.spellsitter) pname src version;
      };
    in
      with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter-optimised-grammars))
        nvim-lspconfig
        lightspeed-nvim
        gitsigns-nvim
        lualine-nvim
        comment-nvim
        tokyonight-nvim
        telescope-nvim
        nvim-cmp
        cmp-nvim-lsp
        cmp_luasnip
        lspkind-nvim
        nvim-ts-rainbow
        fidget-nvim
        luasnip
        spellsitter
      ];
  };
  xdg.configFile."nvim/lua".source = pkgs.callPackage ./fnl {};
}
