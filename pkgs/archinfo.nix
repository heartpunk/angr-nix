{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "9.2.204";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZJ8hlfzo6k97yFxRjF+h6k/YM/q0t7fGyFhMZkuDEG4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "archinfo" ];

  meta = {
    description = "A collection of classes that contain architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = lib.licenses.bsd2;
  };
}
