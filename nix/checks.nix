{ naersk-lib, rust-toolchain, runCommand, cleanSource, ... }:

let
  src = cleanSource ./..;
in
{
  tests = naersk-lib.buildPackage {
    inherit src;
    doCheck = true;
  };

  clippy = naersk-lib.buildPackage {
    inherit src;
    mode = "clippy";
  };

  fmt = runCommand "fmt-check" {
    nativeBuildInputs = [ rust-toolchain ];
  } ''
    cd ${src}
    cargo fmt --all --check
    touch $out
  '';
}
