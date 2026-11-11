# Script reference

This document explains what each script does, why it exists, when it runs, and how to invoke it manually.

## Execution lifecycle

| Order | Script | Trigger | Frequency |
|---|---|---|---|
| 1 | `initialize.sh` | `onCreateCommand` | Container creation |
| 2 | `post-create.sh` | `postCreateCommand` | After creation |
| 3 | `post-start.sh` | `postStartCommand` | Every start |
| Manual | `install-rust-tools.sh` | User command | On demand |
| Manual | `verify-environment.sh` | User command / CI | On demand |

## `initialize.sh`

**Purpose:** perform lightweight first-creation checks.

**What it does:**
1. Enables strict Bash error handling.
2. Confirms `/workspace` exists.
3. Prevents accidental root execution.
4. Makes shell scripts executable when the directory is present.
5. Prints a concise completion message.

**Why it exists:** it catches common mount and permission problems early, before installing developer tools.

**Run manually:**

```bash
bash .devcontainer/scripts/initialize.sh
```

It is safe to run repeatedly and does not install packages or alter project source.

## `post-create.sh`

**Purpose:** install the Rust developer toolchain after container creation.

**What it does:**
1. Sets Cargo and Rustup paths.
2. Confirms `rustup` is available.
3. Confirms the checked-in toolchain manifest exists.
4. Installs the stable toolchain and standard components.
5. Adds the WebAssembly target.
6. Sets stable as the default toolchain.
7. Installs Nextest, cargo-audit, and cargo-deny.

**Why it exists:** OS packages belong in the Docker image, while user-level Rust components belong to the non-root development account.

**Run manually:**

```bash
bash .devcontainer/scripts/post-create.sh
```

The commands can be re-run to repair or refresh the toolchain. Cargo utility installation may update already-installed versions.

## `post-start.sh`

**Purpose:** perform a quick readiness check each time the container starts.

**What it does:**
1. Adds Cargo binaries to `PATH`.
2. Checks whether Cargo is available.
3. Prints Rust/Cargo versions and current user/workspace.

**Why it exists:** it provides quick feedback without repeating expensive installations on every start.

**Run manually:**

```bash
bash .devcontainer/scripts/post-start.sh
```

## `install-rust-tools.sh`

**Purpose:** add optional tools for a particular Rust workload.

**Profiles:**

- `core`: file watching, test runner, security advisory and dependency policy tools.
- `backend`: core tools plus SQLx CLI.
- `wasm`: WebAssembly target, wasm-pack, and Trunk.
- `desktop`: prints framework-specific guidance; native dependencies must be selected for the chosen GUI framework.
- `embedded`: LLVM utilities, cargo-binutils, and probe-rs tools.
- `all`: invokes every profile and may consume significant disk space.

**Examples:**

```bash
bash .devcontainer/scripts/install-rust-tools.sh core
bash .devcontainer/scripts/install-rust-tools.sh wasm
```

**Why it exists:** a single image can support many Rust domains without forcing every SDK into every developer's default environment.

## `verify-environment.sh`

**Purpose:** provide a quick health report.

**What it does:** checks required Rust commands and common native tools, then prints a summary and exits non-zero when required tools are missing.

**Examples:**

```bash
bash .devcontainer/scripts/verify-environment.sh
bash .devcontainer/scripts/verify-environment.sh --strict
```

Strict mode also treats optional utilities as required.

## Error handling conventions

All scripts use `set -Eeuo pipefail` so command failures, unset variables, and pipeline errors are not silently ignored. Scripts print a prefix identifying their source. Do not remove these safeguards without replacing them with equivalent error handling.

## Adding a script

1. Use a descriptive kebab-case filename.
2. Add a purpose comment at the top.
3. Document trigger, inputs, outputs, side effects, and manual invocation here.
4. Use strict Bash mode.
5. Avoid destructive actions and privilege escalation unless essential.
6. Add shell syntax checks to the validation process.
