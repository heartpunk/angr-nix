{
  lib,
  stdenv,
  buildPythonPackage,
  fetchurl,
  autoPatchelfHook,
}:

let
  wheels = {
    x86_64-linux = {
      url = "https://files.pythonhosted.org/packages/34/de/30329041d9a2dda11308576a80b5db17060e4b03a7ba7f550437fb38dd6b/z3_solver-5.1.0.0-py3-none-manylinux_2_27_x86_64.whl";
      hash = "sha256-362eMJ1wELH/a9sz8hVwoWA+9HJzcyIccRenREjwz+8=";
    };
    aarch64-linux = {
      url = "https://files.pythonhosted.org/packages/ec/49/7db70c39fefde52eb5571ae709fa370260536439082d36b9ed1ab36bd1a0/z3_solver-5.1.0.0-py3-none-manylinux_2_38_aarch64.whl";
      hash = "sha256-Hc/My0sCeVHXrfJntbI256Z7hDPMNY2ALcsCgBUVh78=";
    };
    aarch64-darwin = {
      url = "https://files.pythonhosted.org/packages/01/9a/cdb6db09d6aff6a803a94505aa24666db5e47df7aad0f2b1b0ddcb52ed12/z3_solver-5.1.0.0-py3-none-macosx_13_0_arm64.whl";
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
  src = fetchurl {
    inherit (wheel) url hash;
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
