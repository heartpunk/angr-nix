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
  version = "9.2.204";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Io9BLL/ru6XXodD4sC6KV/xBhZ5ESPqNaQe5gAR8yL8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-eO/Ap1cBncA5OhkWIeAol7TCyJ8LhQBkHXnr9RpcFCo=";
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
