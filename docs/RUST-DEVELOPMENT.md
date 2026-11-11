# Rust development workflows

## Standard quality loop

```bash
cargo fmt --all
cargo clippy --all-targets --all-features -- -D warnings
cargo test --all
cargo build --release
```

## Testing

Use the built-in test harness:

```bash
cargo test
```

For larger suites:

```bash
cargo nextest run
```

## Dependency hygiene

```bash
cargo audit
cargo deny check
```

Commit `Cargo.lock` for applications and review dependency changes. For libraries, choose a lockfile policy that matches your release and CI strategy.

## Backend services

The `backend` profile adds SQLx CLI. Database servers should generally run as separate Compose services or external development dependencies rather than being installed into the Rust development container itself.

## WebAssembly

```bash
bash .devcontainer/scripts/install-rust-tools.sh wasm
```

This installs the `wasm32-unknown-unknown` target, `wasm-pack`, and `trunk`. Browser toolchains and deployment configuration remain application-specific.

## Desktop

Desktop frameworks may require GTK, WebKitGTK, system tray libraries, or a host display server. Those dependencies vary by framework and host OS. Add only the required Fedora packages for the chosen project.

## Embedded and cross compilation

```bash
bash .devcontainer/scripts/install-rust-tools.sh embedded
```

You must still install the target-specific compiler/linker, board support, probe drivers, and any host permissions required by your hardware. USB device access is not enabled by default.

## Debugging

GDB and LLDB are installed in the image. For VS Code debugging, configure a project-specific `launch.json` and ensure the binary path and debugger type match your build target.
