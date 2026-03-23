# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2025

SHELL ["powershell", "-NoLogo", "-NoProfile", "-Command", "$ErrorActionPreference = 'Stop';"]

RUN Set-ExecutionPolicy Bypass -Scope Process -Force; `
  [System.Net.ServicePointManager]::SecurityProtocol = `
  [System.Net.SecurityProtocolType]::Tls12; `
  iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

RUN choco feature enable -n allowGlobalConfirmation

RUN choco install `
  git `
  nodejs-lts `
  python `
  golang `
  rust-ms `
  gh `
  7zip `
  curl `
  jq

RUN New-Item -ItemType Directory -Path C:\workspace -Force | Out-Null; `
  New-Item -ItemType Directory -Path C:\hostedtoolcache -Force | Out-Null

ENV RUNNER_TOOL_CACHE="C:\hostedtoolcache"
ENV AGENT_TOOLSDIRECTORY="C:\hostedtoolcache"
ENV GITHUB_WORKSPACE="C:\workspace"
ENV ImageOS="windows2025"
ENV ImageVersion="custom"

WORKDIR C:\workspace
CMD ["powershell", "-NoLogo", "-NoProfile"]