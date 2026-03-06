{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonRelaxDepsHook,
  archinfo,
  pyvex,
  pyxdia,
  uefi-firmware,
  pyelftools,
  pefile,
  sortedcontainers,
  cachetools,
  minidump,
  pyxbe,
  arpy,
  cart,
}:

buildPythonPackage rec {
  pname = "cle";
  version = "9.2.204";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-077Qwf02DJw7g0+l+Je0xSgigTSepAG2H0cyGH/+oB8=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  # arpy in nixpkgs is 2.3.0, cle pins ==1.1.1
  pythonRelaxDeps = [ "arpy" ];

  dependencies = [
    archinfo
    pyvex
    pyxdia
    uefi-firmware
    pyelftools
    pefile
    sortedcontainers
    cachetools
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
