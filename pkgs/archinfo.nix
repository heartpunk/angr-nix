{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "10.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jgAGx35CJm9b1xm3wa1RFu1g8BjJlr0Rwf6JNj60Pjw=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "archinfo" ];

  meta = {
    description = "A collection of classes that contain architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = lib.licenses.bsd2;
  };
}
