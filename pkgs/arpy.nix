{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "arpy";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PsNjCdIjRkjvjc0hGP59gcMBlQh+A1NHNUZYPzQ053Y=";
  };

  build-system = [ setuptools ];
  pythonImportsCheck = [ "arpy" ];

  meta = {
    description = "Library for accessing archive files and reading their contents";
    homepage = "https://github.com/viraptor/arpy";
    license = lib.licenses.bsd2;
  };
}
