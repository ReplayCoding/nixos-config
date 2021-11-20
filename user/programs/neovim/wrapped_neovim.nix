{ symlinkJoin, makeWrapper, lib, gcc, gnumake, neovim, xxd, gopls, clang-tools, llvmPackages_12, rust-analyzer, sumneko-lua-language-server, rnix-lsp, python3 }:

let clang-tools-12 = clang-tools.override { llvmPackages = llvmPackages_12; };
in
symlinkJoin {
  name = "neovim-wrapped";
  paths = [ neovim ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --prefix PATH : ${lib.makeBinPath [
        xxd gcc gnumake gopls clang-tools-12
        rust-analyzer sumneko-lua-language-server
        rnix-lsp ( python3.withPackages (pyPkgs: with pyPkgs; [ python-lsp-server ]) )
      ] }
  '';
}
