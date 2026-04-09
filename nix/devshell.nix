{
  mkShell,
  rust-toolchain,
  pkg-config,
  just,
  cargo-watch,
  cargo-nextest,
  cargo-audit,
  cargo-deny,
  git-cliff,
  cocogitto,
  ...
}:

mkShell {
  nativeBuildInputs = [
    rust-toolchain
    pkg-config
    just
    cargo-watch
    cargo-nextest
    cargo-audit
    cargo-deny
    git-cliff
    cocogitto
  ];

  buildInputs = [
  ];

  env = {
  };

  shellHook = "";
}
