{ symlinkJoin, makeWrapper, lib, gcc, gnumake, neovim, xxd, gopls, clang-tools, rust-analyzer, sumneko-lua-language-server, rnix-lsp, python3 }:

symlinkJoin {
  name = "neovim-wrapped";
  paths = [ neovim ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --prefix PATH : ${lib.makeBinPath [
        xxd gcc gnumake gopls clang-tools
        rust-analyzer sumneko-lua-language-server
        rnix-lsp ( python3.withPackages (pyPkgs: with pyPkgs; [ python-lsp-server ]) )
      ] }
  '';
}
