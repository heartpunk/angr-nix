{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonRelaxDepsHook,
  z3-solver,
  cachetools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "claripy";
  version = "9.2.214";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dznzcQWI49XyyxAJtqwc9QxbR9Su6V0vHYZZwl5H8Co=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRemoveDeps = [ "z3-solver" ];

  dependencies = [
    z3-solver
    cachetools
    typing-extensions
  ];

  pythonImportsCheck = [ "claripy" ];

  meta = {
    description = "An abstraction layer for constraint solvers";
    homepage = "https://github.com/angr/claripy";
    license = lib.licenses.bsd2;
  };
}
