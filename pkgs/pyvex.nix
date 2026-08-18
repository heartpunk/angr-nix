{
  lib,
  buildPythonPackage,
  fetchPypi,
  scikit-build-core,
  cmake,
  ninja,
  cffi,
  bitstring,
  archinfo,
}:

buildPythonPackage rec {
  pname = "pyvex";
  version = "9.2.214";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ti4SIN6LjLFj2OUAyOtuypZBhNeK7605JSZIjN+2RBY=";
  };

  build-system = [
    scikit-build-core
    cmake
    ninja
    cffi
  ];

  dependencies = [
    cffi
    bitstring
    archinfo
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "pyvex" ];

  meta = {
    description = "A Python interface to libVEX and VEX IR";
    homepage = "https://github.com/angr/pyvex";
    license = lib.licenses.bsd2;
  };
}
