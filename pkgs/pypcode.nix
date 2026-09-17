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
  version = "4.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GoP6gXaaLBz+gCStYnl37bme1+y3bbwSciQW+3pU7DQ=";
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
