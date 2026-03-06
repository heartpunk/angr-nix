{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchurl,
  setuptools,
  wheel,
  unzip,
  stdenv,
}:

let
  xdiaZip = fetchurl {
    url = "https://github.com/mborgerson/xdia/releases/download/v0.1.0/xdia.zip";
    hash = "sha256-rtKcSZoL8OUo2l1B/WJYACIu+DFEqahfTvbjeNsmq8s=";
  };
  xdialdrTarXz = fetchurl {
    url = "https://github.com/mborgerson/xdia/releases/download/v0.1.0/xdialdr.tar.xz";
    hash = "sha256-rXL7uVl+TJYYhKrqzkF7YK0nZ+rwSnGKsTyxAN/mlYQ=";
  };
  blinkVersion = "dev-98f95e8";
  blinkPlatforms = {
    "darwin-arm64" = "sha256-vgTU+ibDS2rCYeOcZXV8BmaF9KWPlc3q9oG8Xn32iww=";
    "darwin-x86_64" = lib.fakeHash;
    "linux-aarch64" = "sha256-WqB4ypb8LM1g7EwT3eD2iKoHo2sYlrkc+AXsoyR3mq0=";
  };
  blinkPlatform =
    if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then "darwin-arm64"
    else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64 then "darwin-x86_64"
    else if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64 then "linux-aarch64"
    else null;
  needsBlink = blinkPlatform != null;
  blinkTgz = lib.optionalAttrs needsBlink (fetchurl {
    url = "https://github.com/mborgerson/blink/releases/download/${blinkVersion}/blink-${blinkVersion}-${blinkPlatform}.tgz";
    hash = blinkPlatforms.${blinkPlatform};
  });
in

buildPythonPackage rec {
  pname = "pyxdia";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-r5XRznBAfnoPctArp302bA37DtWPszb4clrI80k7fmg=";
  };

  build-system = [
    setuptools
    wheel
  ];

  nativeBuildInputs = [ unzip ];

  preBuild = ''
    substituteInPlace setup.py \
      --replace-fail "sub_commands = _build.sub_commands + [('check_xdia_install', None)]" \
                     "sub_commands = _build.sub_commands"

    mkdir -p build/lib/pyxdia/bin
    unzip -o ${xdiaZip} -d build/lib/pyxdia/bin
    tar xf ${xdialdrTarXz} -C build/lib/pyxdia/bin
  '' + lib.optionalString needsBlink ''
    tar xzf ${blinkTgz} --strip-components=2 -C build/lib/pyxdia/bin blink-${blinkVersion}-${blinkPlatform}/bin/blink
    tar xzf ${blinkTgz} --strip-components=1 -C build/lib/pyxdia/bin blink-${blinkVersion}-${blinkPlatform}/LICENSE
    mv build/lib/pyxdia/bin/LICENSE build/lib/pyxdia/bin/blink.LICENSE.txt
    chmod 755 build/lib/pyxdia/bin/blink
  '';

  pythonImportsCheck = [ "pyxdia" ];

  meta = {
    description = "Python XDia interface";
    license = lib.licenses.bsd2;
  };
}
