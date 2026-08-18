{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  hatch-vcs,
  hatchling,
  cmake,
  ninja,
  packaging,
  pathspec,
  build,
  cattrs,
  numpy,
  pybind11,
  pytest-subprocess,
  pytestCheckHook,
  setuptools,
  virtualenv,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "scikit-build-core";
  version = "0.11.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-build";
    repo = "scikit-build-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zBTDacTkeclz+/X0SUl1xkxLz4zsfeLOD4Ew0V1Y1iU=";
  };

  patches = [
    # Backport the upstream Darwin test fix used by nixpkgs for 0.11.6.
    (fetchpatch {
      url = "https://github.com/scikit-build/scikit-build-core/commit/c30f52a3b2bd01dc05f23d3b89332c213006afe0.patch";
      excludes = [ ".github/workflows/ci.yml" ];
      hash = "sha256-5E9QfF5UcSNY1wzHzieEEHEPYzPjUTb66CKCodYb9vo=";
    })
  ];

  postPatch = "";

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    packaging
    pathspec
  ];

  nativeCheckInputs = [
    build
    cattrs
    cmake
    ninja
    numpy
    pybind11
    pytest-subprocess
    pytestCheckHook
    setuptools
    virtualenv
    wheel
  ];

  dontUseCmakeConfigure = true;
  setupHooks = [ ./scikit-build-core-append-cmakeFlags.sh ];

  disabledTestMarks = [
    "isolated"
    "network"
  ];

  disabledTestPaths = [
    "tests/test_editable.py"
  ];

  # These assertions are incompatible with newer test-only dependencies in
  # nixpkgs: build 1.5.1 and vcs-versioning 1.1.1 emit warnings that this
  # release's suite promotes to errors, while hatch-vcs now generates an
  # `annotations` name in _version.py.
  disabledTests = [
    "test_all_modules_filter_all"
    "test_prepare_metdata_for_build_wheel"
    "test_pep639_license_files_metadata"
    "test_abi3_wheel"
    "test_pep517_sdist"
    "test_pep517_wheel"
    "test_toml_sdist"
    "test_toml_wheel"
    "test_mixed_wheel"
  ];

  pythonImportsCheck = [ "scikit_build_core" ];

  meta = {
    description = "Next generation Python CMake adaptor and Python API for plugins";
    homepage = "https://github.com/scikit-build/scikit-build-core";
    changelog = "https://github.com/scikit-build/scikit-build-core/blob/${finalAttrs.src.tag}/docs/about/changelog.md";
    license = lib.licenses.asl20;
  };
})
