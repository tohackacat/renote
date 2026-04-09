{
  description = "Rewrite of snotes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      naersk,
      rust-overlay,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };

        rust-toolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
            "clippy"
            "rustfmt"
          ];
          targets = [ "wasm32-unknown-unknown" ];
        };

        naersk-lib = pkgs.callPackage naersk {
          cargo = rust-toolchain;
          rustc = rust-toolchain;
        };

        deps = {
          inherit naersk-lib rust-toolchain;
          inherit (pkgs) lib stdenv pkg-config;
          inherit (pkgs)
            just
            cargo-watch
            cargo-nextest
            cargo-audit
            cargo-deny
            git-cliff
            cocogitto
            ;
          mkShell = pkgs.mkShell;
          runCommand = pkgs.runCommand;
          cleanSource = pkgs.lib.cleanSource;
        };
      in
      {
        packages = import ./nix/packages.nix deps;
        devShells.default = import ./nix/devshell.nix deps;
        checks = import ./nix/checks.nix deps;
      }
    );
}
