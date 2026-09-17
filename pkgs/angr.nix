{
  lib,
  stdenv,
  buildPythonPackage,
  fetchurl,
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
      url = "https://files.pythonhosted.org/packages/18/d3/87fb3341e5ca524f7ad05751864a4cf2dbc5cf4a6fb2c4e4196504c27fb2/angr-10.0.0-cp312-abi3-manylinux_2_28_x86_64.whl";
      hash = "sha256-r6bH0NbKrlO/WBwasaTMbyEpq83ZhwaJvA0ws7K1sYM=";
    };
    aarch64-linux = {
      url = "https://files.pythonhosted.org/packages/35/97/842a688ad6ca7db8ad857aa930cfd4d927f89bc8516e770c39452c672202/angr-10.0.0-cp312-abi3-manylinux_2_28_aarch64.whl";
      hash = "sha256-lLBdpFqn9GMijJh7YC+kLBBa7XWmK9oYMRHnXApDCIQ=";
    };
    aarch64-darwin = {
      url = "https://files.pythonhosted.org/packages/d0/d7/496763c2d6223ef12745211f448dc993890d96479d51bf52efa35583eb7f/angr-10.0.0-cp312-abi3-macosx_11_0_arm64.whl";
      hash = "sha256-no0NolXAdFnmL4Y+RLPTkhivkOqFhGn3/M3/89gvGzk=";
    };
  };
  wheel = wheels.${stdenv.hostPlatform.system}
    or (throw "angr 10.0.0 has no packaged wheel for ${stdenv.hostPlatform.system}");
  z3LibraryDir = "${z3-solver}/${python.sitePackages}/z3/lib";
  pyvexLibraryDir = "${pyvex}/${python.sitePackages}/pyvex/lib";
in
buildPythonPackage rec {
  pname = "angr";
  version = "10.0.0";
  format = "wheel";

  # Upstream's ABI3 wheel includes the Rust claripy/AIL/icicle extension and
  # unicornlib. Keep the existing three-platform support explicit.
  src = fetchurl {
    inherit (wheel) url hash;
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ]
    ++ lib.optionals stdenv.isDarwin [ darwin.cctools ];
  buildInputs = [ stdenv.cc.cc.lib ];
  preFixup = lib.optionalString stdenv.isLinux ''
    addAutoPatchelfSearchPath "${z3LibraryDir}"
    # unicornlib.so needs libpyvex.so, which pyvex ships in its Python lib dir.
    addAutoPatchelfSearchPath "${pyvexLibraryDir}"
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
