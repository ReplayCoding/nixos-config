{ python3Packages, deezer-py, spotipy }:

let
  pname = "deemix";
  version = "3.4.4";
in
python3Packages.buildPythonApplication {
  inherit pname version;

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1d9836cf2b3dda01f58fc59682bcc7ddfa71a050e2f8b3d42e6be5914781f45c";
  };

  propagatedBuildInputs = with python3Packages; [ click requests pycryptodomex mutagen deezer-py spotipy ];
}
