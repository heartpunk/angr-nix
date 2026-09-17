{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "angr-data";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "angr_data";
    inherit version;
    hash = "sha256-2jx5eVeTYXT1oY+SMELmdHxI1OsIcUAPfnK+PmO9/Iw=";
  };

  build-system = [ setuptools ];
  pythonImportsCheck = [ "angr_data" ];

  meta = {
    description = "Function and type prototype definitions for angr";
    homepage = "https://github.com/angr/angr-data";
    license = lib.licenses.bsd2;
  };
}
