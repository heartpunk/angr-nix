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
  version = "9.2.214";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VFjG0wygjG3zPto8u8RXvXA4lPEuKt2gK3fyPhvoINE=";
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
