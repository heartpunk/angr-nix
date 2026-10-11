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
      # Public API: consumers use this overlay to add the pinned Python packages
      # to their nixpkgs Python 3.12 package set.
      overlays.default = final: prev: {
        python312 = prev.python312.override {
          packageOverrides = pfinal: pprev:
            (import ./pkgs/release-wheels.nix { inherit final pfinal pprev; })
            // {
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
              pyxdia = pfinal.callPackage ./pkgs/pyxdia.nix { };
              claripy = pfinal.callPackage ./pkgs/claripy.nix { };
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
