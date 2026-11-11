#!/usr/bin/env bash
# Purpose: Install optional Rust tooling by profile.
# Usage: ./install-rust-tools.sh [core|backend|wasm|desktop|embedded|all]
# Profiles avoid forcing every platform SDK into the default image.
set -Eeuo pipefail

export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"
PROFILE="${1:-core}"

install_cargo() {
  local crate="$1"
  if ! cargo install --list | grep -q "^${crate} v"; then
    cargo install --locked "$crate"
  else
    printf '[tools] %s already installed; skipping.\n' "$crate"
  fi
}

case "$PROFILE" in
  core)
    install_cargo cargo-watch
    install_cargo cargo-nextest
    install_cargo cargo-audit
    install_cargo cargo-deny
    ;;
  backend)
    install_cargo cargo-watch
    install_cargo cargo-nextest
    install_cargo cargo-audit
    install_cargo cargo-deny
    install_cargo sqlx-cli
    ;;
  wasm)
    rustup target add wasm32-unknown-unknown
    install_cargo wasm-pack
    install_cargo trunk
    ;;
  desktop)
    install_cargo cargo-watch
    printf '%s\n' "Desktop GUI system libraries depend on GTK/Tauri version; see docs/RUST-DEVELOPMENT.md."
    ;;
  embedded)
    rustup component add llvm-tools-preview
    install_cargo cargo-binutils
    install_cargo probe-rs-tools
    printf '%s\n' "Install the target-specific linker/debug probe required by your board."
    ;;
  all)
    "$0" core
    "$0" backend
    "$0" wasm
    "$0" desktop
    "$0" embedded
    ;;
  *)
    printf 'Unknown profile: %s\nUsage: %s [core|backend|wasm|desktop|embedded|all]\n' "$PROFILE" "$0" >&2
    exit 2
    ;;
esac
