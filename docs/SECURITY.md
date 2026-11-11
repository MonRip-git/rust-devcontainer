# Security model

## Defaults

- Development runs as the unprivileged `vscode` user.
- The container drops Linux capabilities and adds back only a small set needed for normal user identity and file ownership behavior.
- `no-new-privileges` is enabled.
- No host Docker socket is mounted.
- The workspace is the only source tree bind-mounted by default.

## SSH keys

The Dev Container configuration mounts the host `.ssh` directory to support Git over SSH. Treat this as sensitive access. Use least-privilege keys, agent forwarding where appropriate, and host-side permissions. Remove the mount if SSH access is not required.

## Supply chain

- Review Docker base image updates.
- Keep Cargo dependencies current.
- Run `cargo audit` and `cargo deny check`.
- Prefer lockfiles for applications.
- Review install scripts before executing them.

## Privileged operations

The image grants limited passwordless access to package manager commands. Do not use this for routine development. Avoid adding broad `sudo ALL` permissions.

## Production boundary

This is a development environment, not a hardened production runtime image. Build and deploy production artifacts using a separate, minimal runtime image and CI security controls.
