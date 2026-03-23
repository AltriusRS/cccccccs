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
  jq \
  unzip \
  zip \
  tar \
  xz-utils \
  sudo \
  gnupg \
  lsb-release \
  locales \
  tzdata \
  python3 \
  python3-pip \
  python3-venv \
  nodejs \
  npm \
  bash-completion \
  file \
  procps \
  && locale-gen en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash runner \
  && usermod -aG sudo runner \
  && echo "runner ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/runner \
  && chmod 0440 /etc/sudoers.d/runner \
  && mkdir -p /workspace /opt/hostedtoolcache \
  && chown -R runner:runner /workspace /opt/hostedtoolcache /home/runner

ENV RUNNER_TOOL_CACHE=/opt/hostedtoolcache
ENV AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
ENV GITHUB_WORKSPACE=/workspace
ENV ImageOS=ubuntu
ENV ImageVersion=slim

WORKDIR /workspace
CMD ["/bin/bash"]