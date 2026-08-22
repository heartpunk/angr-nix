{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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
            pypcode = pfinal.callPackage ./pkgs/pypcode.nix { };
            archinfo = pfinal.callPackage ./pkgs/archinfo.nix { };
            pyvex = pfinal.callPackage ./pkgs/pyvex.nix {
              # pyvex 9.2.214 declares scikit-build-core >=0.11.4,<0.12.0.
              scikit-build-core = pfinal.callPackage ./pkgs/scikit-build-core-0.11.nix { };
            };
            claripy = pfinal.callPackage ./pkgs/claripy.nix { };
            cle = pfinal.callPackage ./pkgs/cle.nix { };
            lmdb = pfinal.callPackage ./pkgs/lmdb.nix { lmdb = final.lmdb; };
            angr = pfinal.callPackage ./pkgs/angr.nix { };
          };
        };
      };

      checks = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          scikit-build-core = pkgs.python312Packages.callPackage ./pkgs/scikit-build-core-0.11.nix {
            runTests = true;
          };
        }
      );

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
