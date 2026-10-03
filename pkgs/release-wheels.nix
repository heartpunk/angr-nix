# Prototype packaging of unmodified upstream release wheels. Sources and hashes
# are pinned per platform; no local patches or private Claripy implementation.
{ final, pfinal, pprev }:
let
  releases = builtins.fromJSON (builtins.readFile ./release-wheels.json);
  wheel = name: dependencies: importName:
    let release = releases.${name}; source = release.platforms.${final.stdenv.hostPlatform.system};
    in pprev.buildPythonPackage {
      pname = name;
      inherit (release) version;
      format = "wheel";
      src = final.fetchurl { inherit (source) url hash name; };
      inherit dependencies;
      nativeBuildInputs = final.lib.optionals final.stdenv.isLinux [ final.autoPatchelfHook ];
      buildInputs = final.lib.optionals final.stdenv.isLinux [ final.stdenv.cc.cc.lib ];
      preFixup = final.lib.optionalString (final.stdenv.isLinux && name == "angr") ''
        addAutoPatchelfSearchPath ${pfinal.z3-solver}/${pfinal.python.sitePackages}/z3/lib
      '';
      pythonImportsCheck = [ importName ];
    };
in {
  markdown-it-py = wheel "markdown-it-py" [ pfinal.mdurl ] "markdown_it";
  bitstring = wheel "bitstring" [ pfinal.bitarray ] "bitstring";
  networkx = wheel "networkx" [] "networkx";
  sympy = wheel "sympy" [ pfinal.mpmath ] "sympy";
  mpmath = wheel "mpmath" [] "mpmath";
  cffi = wheel "cffi" [ pfinal.pycparser ] "cffi";
  archinfo = wheel "archinfo" [] "archinfo";
  pyvex = wheel "pyvex" [ pfinal.cffi pfinal.bitstring ] "pyvex";
  cle = (wheel "cle" (with pfinal; [ archinfo pyvex pyxdia uefi-firmware pyelftools pefile sortedcontainers minidump pyxbe arpy cart ]) "cle").overridePythonAttrs {
    nativeBuildInputs = [ pprev.pythonRelaxDepsHook ];
    pythonRelaxDeps = [ "arpy" ];
  };
  uefi-firmware = wheel "uefi-firmware" [ pfinal.future ] "uefi_firmware";
  angr-data = wheel "angr-data" [] "angr_data";
  pypcode = wheel "pypcode" [] "pypcode";
  capstone = wheel "capstone" [] "capstone";
  lmdb = wheel "lmdb" [] "lmdb";
  pycparser = wheel "pycparser" [] "pycparser";
  protobuf = wheel "protobuf" [] "google.protobuf";
  pydemumble = wheel "pydemumble" [] "pydemumble";
  z3-solver = wheel "z3-solver" [] "z3";
  angr = wheel "angr" (with pfinal; [
    archinfo pyvex cle angr-data pypcode capstone networkx sympy cachetools
    sortedcontainers protobuf psutil cffi pycparser rich gitpython lmdb
    mulpyplexer msgspec pydemumble typing-extensions cxxheaderparser
    platformdirs z3-solver
  ]) "angr";
}
