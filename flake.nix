{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      overlays.default = final: prev: {
        python312 = prev.python312.override {
          packageOverrides = pfinal: pprev: {
            uefi-firmware = pfinal.callPackage ./pkgs/uefi-firmware.nix { };
            pyxdia = pfinal.callPackage ./pkgs/pyxdia.nix { };
            pypcode = pfinal.callPackage ./pkgs/pypcode.nix { };
            archinfo = pfinal.callPackage ./pkgs/archinfo.nix { };
            pyvex = pfinal.callPackage ./pkgs/pyvex.nix { };
            claripy = pfinal.callPackage ./pkgs/claripy.nix { };
            cle = pfinal.callPackage ./pkgs/cle.nix { };
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
