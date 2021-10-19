{ python3Packages }:

let
  pname = "deezer-py";
  version = "1.2.2";
in
python3Packages.buildPythonPackage {
  inherit pname version;

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "a491af5fcc9e44a2a28be8832169e703a920dae42c78539f45cad59075700ac9";
  };

  propagatedBuildInputs = with python3Packages; [ requests ];
}
