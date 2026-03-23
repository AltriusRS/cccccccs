FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  wget \
  git \
  git-lfs \
  jq \
  unzip \
  zip \
  tar \
  xz-utils \
  zstd \
  sudo \
  gnupg \
  gpg-agent \
  lsb-release \
  software-properties-common \
  apt-transport-https \
  build-essential \
  pkg-config \
  make \
  cmake \
  ninja-build \
  rsync \
  locales \
  tzdata \
  dnsutils \
  iputils-ping \
  netcat-openbsd \
  openssh-client \
  python3 \
  python3-pip \
  python3-venv \
  python3-dev \
  pipx \
  openjdk-21-jdk \
  golang \
  docker.io \
  docker-compose-v2 \
  sqlite3 \
  libsqlite3-dev \
  shellcheck \
  bash-completion \
  file \
  xxd \
  vim \
  nano \
  less \
  procps \
  psmisc \
  && locale-gen en_US.UTF-8 \
  && git lfs install --system \
  && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash runner \
  && usermod -aG sudo runner \
  && usermod -aG docker runner \
  && echo "runner ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/runner \
  && chmod 0440 /etc/sudoers.d/runner \
  && mkdir -p /workspace /opt/hostedtoolcache \
  && chown -R runner:runner /workspace /opt/hostedtoolcache /home/runner

ENV RUNNER_TOOL_CACHE=/opt/hostedtoolcache
ENV AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
ENV GITHUB_WORKSPACE=/workspace
ENV ImageOS=ubuntu24
ENV ImageVersion=custom
ENV PATH=/home/runner/.cargo/bin:/home/runner/.bun/bin:/usr/local/go/bin:${PATH}

# Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
  && apt-get update \
  && apt-get install -y --no-install-recommends nodejs \
  && npm install -g npm@latest \
  && rm -rf /var/lib/apt/lists/*

# GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  > /etc/apt/sources.list.d/github-cli.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends gh \
  && rm -rf /var/lib/apt/lists/*

# Rust for runner user
USER runner
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y --profile minimal \
  && rustup component add rustfmt clippy

# Bun for runner user
RUN curl -fsSL https://bun.sh/install | bash

# Useful Python CLIs
RUN pipx ensurepath \
  && pipx install yq

USER root

WORKDIR /workspace
CMD ["/bin/bash"]