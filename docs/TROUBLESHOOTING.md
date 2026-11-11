# Troubleshooting

## Docker daemon is unavailable

Check:

```bash
docker version
docker compose version
```

Start or repair the Docker service/desktop application on the host.

## Dev Container build fails while installing Fedora packages

Fedora repositories and package names can change. Rebuild after checking the exact DNF error:

```bash
docker compose -f .devcontainer/docker-compose.yml build --no-cache
```

## Cargo is not found

Inside the container:

```bash
export PATH="$HOME/.cargo/bin:$PATH"
bash .devcontainer/scripts/post-create.sh
```

## Rust analyzer reports a missing toolchain

Confirm the toolchain:

```bash
rustup show
rustup component list --installed
```

Then run `rustup toolchain install stable` and reopen the VS Code window.

## Files are owned by the wrong host user

Set `LOCAL_UID` and `LOCAL_GID` to the host user's numeric IDs before building. Rebuild the container after changing build arguments.

## Cargo downloads repeat

The Compose file uses named volumes for Cargo and Rustup caches. Do not run `docker compose down -v` unless you intentionally want to delete those caches.

## Port is not reachable

Confirm the application listens on `0.0.0.0`, not only `127.0.0.1`, inside the container. Confirm the port is listed in `forwardPorts`.

## Desktop GUI or hardware device is unavailable

GUI display forwarding, USB device access, and embedded probe permissions are host-specific and are intentionally not enabled by default. Follow the framework or board vendor's host integration instructions and add only the required access.
