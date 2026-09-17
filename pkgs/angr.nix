{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python,
  autoPatchelfHook,
  darwin,
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
  platformdirs,
  rich,
  gitpython,
  lmdb,
  mulpyplexer,
  msgspec,
  pydemumble,
  typing-extensions,
  cxxheaderparser,
  z3-solver,
}:

let
  wheels = {
    x86_64-linux = {
      platform = "manylinux_2_28_x86_64";
      hash = "sha256-r6bH0NbKrlO/WBwasaTMbyEpq83ZhwaJvA0ws7K1sYM=";
    };
    aarch64-linux = {
      platform = "manylinux_2_28_aarch64";
      hash = "sha256-lLBdpFqn9GMijJh7YC+kLBBa7XWmK9oYMRHnXApDCIQ=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-no0NolXAdFnmL4Y+RLPTkhivkOqFhGn3/M3/89gvGzk=";
    };
  };
  wheel = wheels.${stdenv.hostPlatform.system}
    or (throw "angr 10.0.0 has no packaged wheel for ${stdenv.hostPlatform.system}");
  z3LibraryDir = "${z3-solver}/${python.sitePackages}/z3/lib";
in
buildPythonPackage rec {
  pname = "angr";
  version = "10.0.0";
  format = "wheel";

  # Upstream's ABI3 wheel includes the Rust claripy/AIL/icicle extension and
  # unicornlib. Keep the existing three-platform support explicit.
  src = fetchPypi {
    inherit pname version;
    inherit (wheel) platform hash;
    format = "wheel";
    python = "cp312";
    abi = "abi3";
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ]
    ++ lib.optionals stdenv.isDarwin [ darwin.cctools ];
  buildInputs = [ stdenv.cc.cc.lib ];
  preFixup = lib.optionalString stdenv.isLinux ''
    addAutoPatchelfSearchPath "${z3LibraryDir}"
  '' + lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libz3.dylib "${z3LibraryDir}/libz3.dylib" \
      "$out/${python.sitePackages}/angr/rustylib.abi3.so"
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
    platformdirs
    rich
    gitpython
    lmdb
    mulpyplexer
    msgspec
    pydemumble
    typing-extensions
    cxxheaderparser
    z3-solver
  ];

  pythonImportsCheck = [ "angr" "angr.claripy" "angr.rustylib" ];

  meta = {
    description = "A powerful and user-friendly binary analysis platform";
    homepage = "https://github.com/angr/angr";
    license = lib.licenses.bsd2;
    platforms = builtins.attrNames wheels;
  };
}
