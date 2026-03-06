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
  version = "9.2.204";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FaidFgkeZTJrA0WzA3Vjo7XisxB2+FNaNlOaW7DQjAI=";
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
