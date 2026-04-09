# Show available recipes
default:
    @just --list

# Build the project
build:
    cargo build

# Build in release mode
build-release:
    cargo build --release

# Run the project
run *ARGS:
    cargo run -- {{ARGS}}

# Run tests
test *ARGS:
    cargo nextest run {{ARGS}}

# Run doc tests
test-doc:
    cargo test --doc

# Run all tests
test-all: test test-doc

# Check formatting
fmt-check:
    cargo fmt --all --check

# Format code
fmt:
    cargo fmt --all

# Run clippy
lint:
    cargo clippy --workspace --all-targets

# Run all checks (fmt + clippy + tests)
check: fmt-check lint test

# Watch for changes and rebuild
watch:
    cargo watch -x build

# Watch for changes and run tests
watch-test:
    cargo watch -x 'nextest run'

# Run cargo audit
audit:
    cargo audit

# Run cargo deny
deny:
    cargo deny check

# All checks, audit and deny
ci: check audit deny

# Generate changelog
changelog:
    git cliff -o CHANGELOG.md

# Check commit messages
commit-check:
    cog check

# Set up git hooks
setup:
    cog install-hook --all

# Clean build artifacts
clean:
    cargo clean
