{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-rust,
  rustPlatform,
  cargo,
  rustc,
  angr-data,
  archinfo,
  pyvex,
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
  mulpyplexer,
  msgspec,
  pydemumble,
  typing-extensions,
  cxxheaderparser,
  gnumake,
  grpcio-tools,
  z3-solver,
  platformdirs,
  autoPatchelfHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "angr";
  version = "10.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CCpzJGP+/ZK107+Nnp/ERYtIzw6MlPgPJ30lX8sjKNk=";
  };

  patches = [ ../patches/fp-smt-significand.patch ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-EVTtVUdkZGN8VF8fHGzWSkR7F2Q09ItPaLjzjyJRLFs=";
  };

  build-system = [
    setuptools
    setuptools-rust
    grpcio-tools
    pyvex
    z3-solver
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    gnumake
  ] ++ lib.optionals stdenv.isLinux [ autoPatchelfHook
  ];

  buildInputs = [ stdenv.cc.cc.lib ];
  preFixup = lib.optionalString stdenv.isLinux ''
    addAutoPatchelfSearchPath ${z3-solver}/${z3-solver.pythonModule.sitePackages}/z3/lib
    addAutoPatchelfSearchPath ${pyvex}/${pyvex.pythonModule.sitePackages}/pyvex/lib
  '';

  dependencies = [
    angr-data
    archinfo
    pyvex
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
    mulpyplexer
    msgspec
    pydemumble
    typing-extensions
    cxxheaderparser
    platformdirs
    z3-solver
  ];

  pythonImportsCheck = [ "angr" ];

  meta = {
    description = "A powerful and user-friendly binary analysis platform";
    homepage = "https://github.com/angr/angr";
    license = lib.licenses.bsd2;
  };
}
