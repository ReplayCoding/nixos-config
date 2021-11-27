{ lib
, buildGoModule
, fetchFromSourcehut
, scdoc
}:

buildGoModule rec {
  pname = "astronaut";
  version = "121edc7513148a3e3ae981ac88e9878ceb1d533b";

  src = fetchFromSourcehut {
    owner = "~adnano";
    repo = pname;
    rev = version;
    sha256 = "sha256-xvmbrTg3Qj88my27bk8VN7pcyJ2fX31t3Orl4Mzzj2M=";
  };

  vendorSha256 = "sha256-7SyawlfJ9toNVuFehGr5GQF6mNmS9E4kkNcqWllp8No=";

  nativeBuildInputs = [ scdoc ];

  buildPhase = "
    runHook preBuild
    # we use make instead of go build
    runHook postBuild
  ";

  installPhase = ''
    runHook preInstall
    make PREFIX=$out install
  '';

  meta = with lib; {
    description = "A Gemini browser for the terminal.";
    homepage = "https://hub.sr.ht/~adnano/astronaut/";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
