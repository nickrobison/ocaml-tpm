{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
            inherit system;
          };
      in
        with pkgs;
      {
        defaultPackage = (callPackage ./nix/mssim.nix {}).mssim;
        devShells.default = mkShell {
          buildInputs = [];
        };
      });
  }
