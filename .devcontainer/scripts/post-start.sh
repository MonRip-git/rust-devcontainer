#!/usr/bin/env bash
# Purpose: Perform lightweight checks each time the container starts.
# What it does: confirms Rust/Cargo are reachable and prints a short environment summary.
# Safe to re-run: yes; this script does not install or change software.
set -Eeuo pipefail

export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"
log() { printf '[post-start] %s\n' "$*"; }

if ! command -v cargo >/dev/null 2>&1; then
  log "WARNING: cargo is not on PATH. Run post-create.sh or reopen the container."
  exit 0
fi

log "Container ready: $(rustc --version) | $(cargo --version)"
log "User: $(id -un) (uid=$(id -u)); workspace: ${PWD}"
