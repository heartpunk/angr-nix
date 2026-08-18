{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "9.2.214";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qjx6h9/78DlZa4yA04KO6DokZfsgVveQ6x4WlgXS2rc=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "archinfo" ];

  meta = {
    description = "A collection of classes that contain architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = lib.licenses.bsd2;
  };
}
