{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  autoPatchelfHook,
}:

let
  wheels = {
    x86_64-linux = {
      platform = "manylinux_2_27_x86_64";
      hash = "sha256-362eMJ1wELH/a9sz8hVwoWA+9HJzcyIccRenREjwz+8=";
    };
    aarch64-linux = {
      platform = "manylinux_2_38_aarch64";
      hash = "sha256-Hc/My0sCeVHXrfJntbI256Z7hDPMNY2ALcsCgBUVh78=";
    };
    aarch64-darwin = {
      platform = "macosx_13_0_arm64";
      hash = "sha256-OZo4qF14QQXl31oFwEpYFIG/24CvdCR3nPdvqEO05mw=";
    };
  };
  wheel = wheels.${stdenv.hostPlatform.system}
    or (throw "z3-solver 5.1.0.0 has no packaged wheel for ${stdenv.hostPlatform.system}");
in
buildPythonPackage rec {
  pname = "z3-solver";
  version = "5.1.0.0";
  format = "wheel";

  # angr's Rust extension and Python bindings must load this same libz3;
  # preserve the upstream z3/lib layout expected by angr._z3.library_dir.
  src = fetchPypi {
    pname = "z3_solver";
    inherit version;
    inherit (wheel) platform hash;
    format = "wheel";
    python = "py3";
    abi = "none";
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];
  pythonImportsCheck = [ "z3" ];

  meta = {
    description = "Python bindings and matching native library for the Z3 theorem prover";
    homepage = "https://github.com/Z3Prover/z3";
    license = lib.licenses.mit;
    platforms = builtins.attrNames wheels;
  };
}
