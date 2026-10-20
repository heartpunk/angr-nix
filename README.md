# angr-nix

Nix flake packaging for [angr](https://github.com/angr/angr) 10.0.1, a binary analysis framework.
Angr is built from pinned upstream source with an SMT-LIB floating-point export
correction. Dependencies use stock Nixpkgs packages where compatible; required
version overrides use pinned upstream wheels or source.

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
| angr | 10.0.1 | Upstream source with the FP SMT export correction |
| cle | 10.0.1 | Binary loader; official upstream wheel |
| pyvex | 10.0.1 | VEX IR lifter; official upstream wheel |
| archinfo | 10.0.1 | Architecture definitions; official upstream wheel |
| angr-data | 0.1.1 | Runtime data required by Angr 10 |
| pypcode | 4.0.0 | SLEIGH disassembler; official upstream wheel |
| z3-solver | 5.1.0.0 | Solver runtime; official upstream wheel |

Wheel URLs and hashes are recorded in `pkgs/release-wheels.json`;
`pkgs/release-wheels.nix` selects the active overrides. Angr 10 supplies its own
Claripy implementation. The overlay does not override standalone Claripy.

## Platforms

- `x86_64-linux`
- `aarch64-linux`
- `aarch64-darwin` (Apple Silicon)

The overlay retains Angr 10 version requirements while reusing ordinary Nixpkgs
packaging. CLE retains the existing `arpy` dependency relaxation.

## License

MIT
