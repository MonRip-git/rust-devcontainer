#!/usr/bin/env bash
# Purpose: Prepare the Rust toolchain after the container is first created.
# What it does: loads rustup, installs the toolchain/components/targets declared in config,
# and installs a small baseline of useful Cargo utilities.
# Safe to re-run: yes; rustup and cargo install are idempotent or update existing tools.
set -Eeuo pipefail

log() { printf '[post-create] %s\n' "$*"; }
fail() { log "ERROR: $*"; exit 1; }

export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.rustup}"
export PATH="$CARGO_HOME/bin:$PATH"

command -v rustup >/dev/null 2>&1 || fail "rustup is not installed."
TOOLCHAIN_FILE="/workspace/.devcontainer/config/rust-toolchain.toml"
[[ -f "$TOOLCHAIN_FILE" ]] || fail "Missing $TOOLCHAIN_FILE"

log "Installing the toolchain and components declared by rust-toolchain.toml."
rustup toolchain install stable --profile default
rustup component add rustfmt clippy rust-analyzer --toolchain stable
rustup target add wasm32-unknown-unknown --toolchain stable
rustup default stable

log "Installing baseline Cargo developer utilities."
cargo install --locked cargo-nextest
cargo install --locked cargo-audit
cargo install --locked cargo-deny

log "Rust environment prepared."
rustc --version
cargo --version
