{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-rust,
  pythonRelaxDepsHook,
  rustPlatform,
  cargo,
  rustc,
  archinfo,
  pyvex,
  claripy,
  cle,
  pypcode,
  capstone,
  networkx,
  sympy,
  cachetools,
  sortedcontainers,
  protobuf,
  psutil,
  cffi,
  pycparser,
  rich,
  gitpython,
  lmdb,
  pycryptodome,
  mulpyplexer,
  msgspec,
  pydemumble,
  typing-extensions,
  cxxheaderparser,
  gnumake,
}:

buildPythonPackage rec {
  pname = "angr";
  version = "9.2.214";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-umCAv9Gxz1/LNFCMbV4XSq5PgkFsJdwodI3I5UJtiRU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-WPMBFVb+D8eWkF25doTYcFM7s8XRgkoaHXL0rtLwoqk=";
  };

  build-system = [
    setuptools
    setuptools-rust
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
    gnumake
  ];

  # capstone: nixpkgs 5.0.7 vs pinned 5.0.6
  pythonRelaxDeps = [ "capstone" ];

  dependencies = [
    archinfo
    pyvex
    claripy
    cle
    pypcode
    capstone
    networkx
    sympy
    cachetools
    sortedcontainers
    protobuf
    psutil
    cffi
    pycparser
    rich
    gitpython
    lmdb
    pycryptodome
    mulpyplexer
    msgspec
    pydemumble
    typing-extensions
    cxxheaderparser
  ];

  pythonImportsCheck = [ "angr" ];

  meta = {
    description = "A powerful and user-friendly binary analysis platform";
    homepage = "https://github.com/angr/angr";
    license = lib.licenses.bsd2;
  };
}
