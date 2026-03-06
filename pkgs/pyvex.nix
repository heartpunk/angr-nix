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
  version = "9.2.204";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c48Q/6ujs7og+AronXouRVF4Ay9eZW+uI5+T6K4YjXE=";
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
