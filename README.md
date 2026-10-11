# angr-nix

Nix flake packaging for [angr](https://github.com/angr/angr) 10.0.1, a binary analysis framework.
The Angr 10 package and its native/runtime dependencies use pinned upstream release
wheels; Nix supplies the Python 3.12 environment and the libraries needed to load
the native extensions.

## Usage

### Run directly

```bash
nix run github:heartpunk/angr-nix -- -c "import angr; print(angr.__version__)"
```

### Dev shell

```bash
nix develop github:heartpunk/angr-nix
python -c "import angr; p = angr.Project('/bin/ls', auto_load_libs=False); print(p.arch)"
```

### From FlakeHub

```bash
nix run "https://flakehub.com/f/heartpunk/angr-nix/*" -- -c "import angr; print(angr.__version__)"
```

### As a flake input

```nix
{
  # From GitHub
  inputs.angr-nix.url = "github:heartpunk/angr-nix";

  # Or from FlakeHub (with semver)
  # inputs.angr-nix.url = "https://flakehub.com/f/heartpunk/angr-nix/*";

  outputs = { self, nixpkgs, angr-nix }: {
    # Use the overlay
    packages.x86_64-linux.default = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ angr-nix.overlays.default ];
      };
    in pkgs.python312.withPackages (ps: [ ps.angr ]);
  };
}
```

## What's packaged

Core runtime packages provided by this flake:

| Package | Version | Notes |
|---------|---------|-------|
| angr | 10.0.1 | Official upstream wheel |
| cle | 10.0.1 | Binary loader; official upstream wheel |
| pyvex | 10.0.1 | VEX IR lifter; official upstream wheel |
| archinfo | 10.0.1 | Architecture definitions; official upstream wheel |
| angr-data | 0.1.1 | Runtime data required by Angr 10 |
| pypcode | 4.0.0 | SLEIGH disassembler; official upstream wheel |
| z3-solver | 5.1.0.0 | Solver runtime; official upstream wheel |
| claripy | 9.2.214 | Separately exposed legacy package; not in the Angr 10 dependency closure and not yet checked for Angr 10 compatibility |

Other runtime wheels and their hashes are pinned in `pkgs/release-wheels.json`.
The overlay also retains source-built packages for consumers that are not replaced
by the release-wheel set.

## Platforms

- `x86_64-linux`
- `aarch64-linux`
- `aarch64-darwin` (Apple Silicon)

The release-wheel closure pins its runtime packages rather than relaxing
Angr 9 package constraints against nixpkgs. The separately exposed legacy
Claripy and source-built packages retain their own existing dependency rules.

## License

MIT
