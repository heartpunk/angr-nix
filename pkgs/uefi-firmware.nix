{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  future,
}:

buildPythonPackage rec {
  pname = "uefi-firmware";
  version = "1.16";
  pyproject = true;

  src = fetchPypi {
    pname = "uefi_firmware";
    inherit version;
    hash = "sha256-Fia5kwsQBvnsELde+In/wXxjLgtDpKugehCQ2QIxM+o=";
  };

  build-system = [ setuptools setuptools-scm ];

  dependencies = [ future ];

  pythonImportsCheck = [ "uefi_firmware" ];

  meta = {
    description = "Parse and extract common UEFI firmware volumes";
    homepage = "https://github.com/theopolis/uefi-firmware-parser";
    license = lib.licenses.bsd2;
  };
}
