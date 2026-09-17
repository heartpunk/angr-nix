{
  lib,
  buildPythonPackage,
  fetchPypi,
  scikit-build-core,
  cmake,
  ninja,
}:

buildPythonPackage rec {
  pname = "pydemumble";
  version = "0.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n4y5CZEk1vmq5i3r5jGCgnn8I24mfULm1EzklBlGBE0=";
  };

  # Upstream builds the nanobind source bundled in the sdist.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "nanobind >=1.3.2"' ""
  '';

  build-system = [ scikit-build-core ];
  nativeBuildInputs = [ cmake ninja ];
  dontUseCmakeConfigure = true;
  pythonImportsCheck = [ "pydemumble" ];

  meta = {
    description = "Python wrapper for the demumble symbol demangler";
    homepage = "https://github.com/angr/pydemumble";
    license = lib.licenses.bsd2;
  };
}
