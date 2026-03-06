# angr-nix

Nix flake packaging [angr](https://github.com/angr/angr) 9.2.204, a binary analysis framework.

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

### As a flake input

```nix
{
  inputs.angr-nix.url = "github:heartpunk/angr-nix";

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

These packages are not in nixpkgs and are built by this flake:

| Package | Version | Notes |
|---------|---------|-------|
| angr | 9.2.204 | Rust extension (pyo3) |
| cle | 9.2.204 | Binary loader |
| claripy | 9.2.204 | Constraint solver interface |
| pyvex | 9.2.204 | VEX IR lifter (native C) |
| archinfo | 9.2.204 | Architecture definitions |
| pypcode | 3.2.1 | SLEIGH disassembler (native C++) |
| pyxdia | 0.1.0 | XDia debug info interface |
| uefi-firmware | 1.11 | UEFI firmware parser |

## Platforms

- `x86_64-linux` — tested
- `aarch64-darwin` — builds defined, pending DNS fix on test machine

## Version pins relaxed

- `capstone`: nixpkgs 5.0.7 vs angr's pinned 5.0.6
- `z3-solver`: nixpkgs 4.15.8 vs claripy's pinned 4.13.0.0
- `arpy`: nixpkgs 2.3.0 vs cle's pinned 1.1.1

## License

MIT
