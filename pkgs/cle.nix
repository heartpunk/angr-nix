{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  archinfo,
  pyvex,
  pyxdia,
  uefi-firmware,
  pyelftools,
  pefile,
  sortedcontainers,
  minidump,
  pyxbe,
  arpy,
  cart,
}:

buildPythonPackage rec {
  pname = "cle";
  version = "10.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rhjs8xGZIr/ZiD37/Zo5sLBUp7OQgxwxbSAXLzu6m/M=";
  };

  build-system = [ setuptools ];


  dependencies = [
    archinfo
    pyvex
    pyxdia
    uefi-firmware
    pyelftools
    pefile
    sortedcontainers
    minidump
    pyxbe
    arpy
    cart
  ];

  pythonImportsCheck = [ "cle" ];

  meta = {
    description = "CLE loads binaries";
    homepage = "https://github.com/angr/cle";
    license = lib.licenses.bsd2;
  };
}
