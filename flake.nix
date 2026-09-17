{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/e7a3ca8092b61ff85b6a45bf863ea2b2d6a661b3";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
"aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      overlays.default = final: prev: {
        python312 = prev.python312.override {
          packageOverrides = pfinal: pprev: {
            mistune = pprev.mistune.overrideAttrs (old: {
              # Wall-clock ratio assertions flake under concurrent build load.
              disabledTests = (old.disabledTests or [ ]) ++ [
                "near_linear"
              ];
            });
            httpcore2 = pprev.httpcore2.overrideAttrs (old: {
              # The Trio 10 ms cancellation check passes in isolation but flakes
              # under concurrent build load before cleanup reaches the idle state.
              pytestFlags = (old.pytestFlags or [ ]) ++ [
                "--deselect=tests/httpcore2/test_cancellations.py::test_h2_timeout_during_response[trio]"
              ];
            });
            uefi-firmware = pfinal.callPackage ./pkgs/uefi-firmware.nix { };
            pyxdia = pfinal.callPackage ./pkgs/pyxdia.nix { };
            arpy = pfinal.callPackage ./pkgs/arpy.nix { };
            pydemumble = pfinal.callPackage ./pkgs/pydemumble.nix { };
            pypcode = pfinal.callPackage ./pkgs/pypcode.nix { };
            archinfo = pfinal.callPackage ./pkgs/archinfo.nix { };
            pyvex = pfinal.callPackage ./pkgs/pyvex.nix { };
            angr-data = pfinal.callPackage ./pkgs/angr-data.nix { };
            capstone = pfinal.callPackage ./pkgs/capstone.nix { };
            z3-solver = pfinal.callPackage ./pkgs/z3-solver.nix { };
            cle = pfinal.callPackage ./pkgs/cle.nix { };
            lmdb = pfinal.callPackage ./pkgs/lmdb.nix { lmdb = final.lmdb; };
            angr = pfinal.callPackage ./pkgs/angr.nix { };
          };
        };
      };

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          default = pkgs.python312.withPackages (ps: [ ps.angr ]);
          angr = pkgs.python312Packages.angr;
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          default = pkgs.mkShell {
            packages = [
              (pkgs.python312.withPackages (ps: [
                ps.angr
                ps.ipython
              ]))
            ];
          };
        }
      );
    };
}
