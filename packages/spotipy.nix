{ python3Packages }:

let pname = "spotipy";
    version = "2.19.0";
in
python3Packages.buildPythonPackage {
  inherit pname version;


  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "904f6e813dba837758e9510c1bee51d7ca217f169246625a13e693733dc33543";
  };

  doCheck = false;
  propagatedBuildInputs = with python3Packages; [ requests six ];
}
