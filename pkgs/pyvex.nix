{
  lib,
  buildPythonPackage,
  fetchPypi,
  scikit-build-core,
  cmake,
  ninja,
  cffi,
  bitstring,
}:

buildPythonPackage rec {
  pname = "pyvex";
  version = "10.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+09qhcxqFi26pz8OFzQPMq7Mz8yc6wgSIWjSo/3q3+U=";
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
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "pyvex" ];

  meta = {
    description = "A Python interface to libVEX and VEX IR";
    homepage = "https://github.com/angr/pyvex";
    license = lib.licenses.bsd2;
  };
}
