{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cmake,
}:

buildPythonPackage rec {
  pname = "capstone";
  version = "5.0.9";
  pyproject = true;

  # The sdist bundles the matching native sources; setup.py builds and installs
  # libcapstone alongside the bindings on both Linux and Darwin.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BCmvKS3cYE08k0RpaAfigdXnKNsCnwDmpOqeO/8arJ4=";
  };

  build-system = [ setuptools ];
  nativeBuildInputs = lib.optionals stdenv.isDarwin [ cmake ];
  dontUseCmakeConfigure = true;
  pythonImportsCheck = [ "capstone" ];

  meta = {
    description = "Python bindings for the Capstone disassembly engine";
    homepage = "https://www.capstone-engine.org/";
    license = lib.licenses.bsd3;
  };
}
