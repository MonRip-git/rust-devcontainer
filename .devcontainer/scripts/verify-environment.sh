#!/usr/bin/env bash
# Purpose: Validate the development environment and return a useful pass/fail report.
# Usage: ./verify-environment.sh [--strict]
# Strict mode exits non-zero if any optional tool is missing.
set -Eeuo pipefail

STRICT="${1:-}"
export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"
failures=0
warnings=0

check() {
  local name="$1" command_name="$2" required="${3:-yes}"
  if command -v "$command_name" >/dev/null 2>&1; then
    printf '  [OK]   %-20s %s\n' "$name" "$("$command_name" --version 2>/dev/null | head -n1 || true)"
  else
    if [[ "$required" == "yes" || "$STRICT" == "--strict" ]]; then
      printf '  [FAIL] %s (%s not found)\n' "$name" "$command_name"
      failures=$((failures + 1))
    else
      printf '  [WARN] %s (%s not found)\n' "$name" "$command_name"
      warnings=$((warnings + 1))
    fi
  fi
}

printf '\nRust DevContainer environment verification\n'
printf '%s\n' '------------------------------------------'
check "Rust compiler" rustc
check "Cargo" cargo
check "Rust formatter" rustfmt
check "Clippy" cargo-clippy
check "Git" git
check "C compiler" gcc
check "C++ compiler" g++
check "Clang" clang no
check "CMake" cmake no
check "Ninja" ninja no
check "GDB" gdb no
check "LLDB" lldb no

printf '\nSummary: %d failure(s), %d warning(s)\n' "$failures" "$warnings"
[[ "$failures" -eq 0 ]] || exit 1
