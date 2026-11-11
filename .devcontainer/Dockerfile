# Fedora 45 development image. Pin to the major release for predictable OS behavior.
FROM fedora:45

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    SHELL=/usr/bin/zsh \
    CARGO_HOME=/home/${USERNAME}/.cargo \
    RUSTUP_HOME=/home/${USERNAME}/.rustup \
    PATH=/home/${USERNAME}/.cargo/bin:${PATH}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Base system packages and common native build dependencies.
RUN dnf -y upgrade --refresh && \
    dnf -y install \
      bash-completion ca-certificates curl wget git git-lfs openssh-clients \
      sudo shadow-utils findutils which procps-ng iproute hostname \
      gcc gcc-c++ clang llvm lld lldb gdb make cmake ninja-build pkgconf-pkg-config \
      openssl-devel zlib-devel libffi-devel sqlite-devel \
      postgresql-devel libxml2-devel \
      python3 python3-pip perl \
      tar gzip xz unzip zip jq yq \
      zsh util-linux-user \
      glibc-langpack-en \
      && dnf clean all && rm -rf /var/cache/dnf

# Create a predictable non-root development identity.
RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} --create-home \
      --shell /usr/bin/zsh ${USERNAME} && \
    echo "${USERNAME} ALL=(root) NOPASSWD: /usr/bin/dnf, /usr/bin/dnf5" \
      > /etc/sudoers.d/${USERNAME} && chmod 0440 /etc/sudoers.d/${USERNAME} && \
    mkdir -p /workspace && chown -R ${USERNAME}:${USERNAME} /workspace

# Install Starship for a consistent shell prompt.
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

USER ${USERNAME}
WORKDIR /workspace

# Install rustup without running as root. Toolchain and components are pinned/configured
# in rust-toolchain.toml and are installed during post-create.
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --profile minimal --default-toolchain stable && \
    mkdir -p "${CARGO_HOME}/bin" "${RUSTUP_HOME}"

COPY --chown=${USERNAME}:${USERNAME} config/starship.toml /tmp/starship.toml
RUN mkdir -p /home/${USERNAME}/.config && \
    cp /tmp/starship.toml /home/${USERNAME}/.config/starship.toml && \
    printf '\\neval "$(starship init zsh)"\\n' >> /home/${USERNAME}/.zshrc && \
    printf '\\neval "$(starship init bash)"\\n' >> /home/${USERNAME}/.bashrc

ENV PATH="${CARGO_HOME}/bin:${PATH}"
CMD ["sleep", "infinity"]
