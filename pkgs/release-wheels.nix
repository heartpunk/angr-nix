# Required upstream release wheels, pinned by platform and hash.
# Angr itself is built from source below with the SMT exporter correction.
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
      pythonImportsCheck = [ importName ];
    };
in {
  archinfo = wheel "archinfo" [] "archinfo";
  pyvex = wheel "pyvex" [ pfinal.cffi pfinal.bitstring ] "pyvex";
  cle = (wheel "cle" (with pfinal; [ archinfo pyvex pyxdia uefi-firmware pyelftools pefile sortedcontainers minidump pyxbe arpy cart ]) "cle").overridePythonAttrs {
    pythonRelaxDeps = [ "arpy" ];
  };
  uefi-firmware = wheel "uefi-firmware" [ pfinal.future ] "uefi_firmware";
  angr-data = wheel "angr-data" [] "angr_data";
  pypcode = wheel "pypcode" [] "pypcode";
  lmdb = wheel "lmdb" [] "lmdb";
  grpcio-tools = wheel "grpcio-tools" [ pfinal.grpcio pfinal.protobuf pfinal.setuptools ] "grpc_tools";
  protobuf = wheel "protobuf" [] "google.protobuf";
  pydemumble = wheel "pydemumble" [] "pydemumble";
  z3-solver = wheel "z3-solver" [] "z3";
  # Build the pinned release source to apply the public SMT exporter correction.
  angr = pfinal.callPackage ./angr-source.nix { };
}
