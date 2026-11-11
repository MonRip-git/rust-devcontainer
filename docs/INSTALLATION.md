# Installation and first run

## Host prerequisites

Install Docker Engine or Docker Desktop, Docker Compose v2, VS Code, and the Microsoft Dev Containers extension.

Confirm Docker is available:

```bash
docker version
docker compose version
```

## Open the template

1. Clone this repository.
2. Open its root directory in VS Code.
3. Open the Command Palette.
4. Select **Dev Containers: Reopen in Container**.
5. Wait for the first build and Rust setup to finish.

The first setup downloads Rust components and Cargo tools; it may take several minutes.

## Start without VS Code

Build and start the Compose service:

```bash
docker compose -f .devcontainer/docker-compose.yml up -d --build
```

Open a shell:

```bash
docker compose -f .devcontainer/docker-compose.yml exec rust-dev zsh
```

Stop it:

```bash
docker compose -f .devcontainer/docker-compose.yml down
```

## Integrate into an existing repository

Copy `.devcontainer/` to the root of the target repository. The Dev Container mounts that repository as `/workspace`.

If your host UID/GID is not 1000, set `LOCAL_UID` and `LOCAL_GID` in the environment before building where supported by your shell:

```bash
export LOCAL_UID="$(id -u)"
export LOCAL_GID="$(id -g)"
```

## Verify

Inside the container:

```bash
bash .devcontainer/scripts/verify-environment.sh
```

For strict verification, which also treats optional tools as required:

```bash
bash .devcontainer/scripts/verify-environment.sh --strict
```
