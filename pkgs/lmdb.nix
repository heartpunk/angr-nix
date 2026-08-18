{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  patch-ng,
  pytestCheckHook,
  cffi,
  lmdb,
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "2.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AxcGIyauL2bju95kAJB2UepYwnolAJdRGijRPEZ/pfE=";
  };

  build-system = [ setuptools ];
  buildInputs = [ lmdb ];
  nativeBuildInputs = [ cffi ];
  env.LMDB_FORCE_SYSTEM = 1;
  dependencies = [ patch-ng ];
  pythonImportsCheck = [ "lmdb" ];
  nativeCheckInputs = [ pytestCheckHook ];

  # The source-tree test phase cannot see the wheel's lmdb.cpython extension
  # and silently falls back to the optional CFFI backend, which crashes on
  # Darwin. Keep checking the installed CPython package via imports instead.
  doCheck = false;

  meta = {
    description = "Universal Python binding for the LMDB 'Lightning' Database";
    homepage = "https://github.com/dw/py-lmdb";
    changelog = "https://github.com/jnwatson/py-lmdb/blob/py-lmdb_${version}/ChangeLog";
    license = lib.licenses.openldap;
  };
}
