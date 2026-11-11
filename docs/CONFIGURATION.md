# Configuration reference

## Fedora image

`.devcontainer/Dockerfile` uses `fedora:45`. The major version is explicit to avoid silently switching to a later Fedora release.

## Rust toolchain

`.devcontainer/config/rust-toolchain.toml` declares the Rust channel, profile, components, and targets. Change this file to pin a specific Rust version or add target triples.

## VS Code

`.devcontainer/devcontainer.json` declares extensions, formatting defaults, Clippy-on-save checking, ports, and lifecycle hooks.

## Docker Compose

`.devcontainer/docker-compose.yml` defines the development service, workspace mount, cache volumes, resource limits, and container security options.

The container does not mount the host Docker socket. If a project genuinely needs Docker-from-inside-container, assess the security implications before adding it.

## Environment variables

| Variable | Default | Meaning |
|---|---|---|
| `CARGO_HOME` | `/home/vscode/.cargo` | Cargo downloads and installed binaries |
| `RUSTUP_HOME` | `/home/vscode/.rustup` | Rustup toolchains |
| `RUST_BACKTRACE` | `1` | Enables backtraces for Rust panics |
| `RUST_LOG` | `info` | Default filter for tracing-compatible apps |

## Ports

Ports 3000, 8000, and 8080 are forwarded as common development defaults. Add or remove ports in `devcontainer.json` to match your application.
