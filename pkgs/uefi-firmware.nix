{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  future,
}:

buildPythonPackage rec {
  pname = "uefi-firmware";
  version = "1.11";
  pyproject = true;

  src = fetchPypi {
    pname = "uefi_firmware";
    inherit version;
    hash = "sha256-MOKp0TisFgi9/BeDqTaTHrb0KScjkZ8dssFQnsGKYEE=";
  };

  build-system = [ setuptools ];

  dependencies = [ future ];

  pythonImportsCheck = [ "uefi_firmware" ];

  meta = {
    description = "Parse and extract common UEFI firmware volumes";
    homepage = "https://github.com/theopolis/uefi-firmware-parser";
    license = lib.licenses.bsd2;
  };
}
