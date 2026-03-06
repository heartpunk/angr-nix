{
  lib,
  buildPythonPackage,
  fetchPypi,
  cmake,
  ninja,
  nanobind,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pypcode";
  version = "3.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JFtqGvCMrm3iMSPEHmhuE4B0tevVYTE4Es+hLlJu0lk=";
  };

  build-system = [
    setuptools
    cmake
    ninja
    nanobind
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "pypcode" ];

  meta = {
    description = "Python bindings for Ghidra's SLEIGH library";
    homepage = "https://github.com/angr/pypcode";
    license = lib.licenses.asl20;
  };
}
