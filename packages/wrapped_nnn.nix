{ symlinkJoin, makeWrapper, lib, nnn, file, findutils /* for xargs */, gnused, coreutils, gnutar, unzip }:

symlinkJoin {
  name = "nnn-wrapped";
  paths = [ 
    ( nnn.override { withNerdIcons = true; } )
  ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nnn \
      --add-flags "-e" \
      --prefix PATH : ${lib.makeBinPath [ file findutils gnused coreutils gnutar unzip ] }
  '';
}
