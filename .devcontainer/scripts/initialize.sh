#!/usr/bin/env bash
# Purpose: Run once when the Dev Container is created.
# What it does: verifies the expected workspace and makes project helper scripts executable.
# Safe to re-run: yes. It does not install packages or modify project source files.
set -Eeuo pipefail

log() { printf '[initialize] %s\n' "$*"; }
fail() { log "ERROR: $*"; exit 1; }

[[ -d /workspace ]] || fail "/workspace is missing; check the workspace mount."
[[ "$(id -u)" -ne 0 ]] || fail "Do not run this script as root."

if [[ -d /workspace/.devcontainer/scripts ]]; then
  find /workspace/.devcontainer/scripts -maxdepth 1 -type f -name '*.sh' -exec chmod u+x {} +
fi

log "Workspace is mounted and the non-root identity is active."
log "Initialization checks completed."
