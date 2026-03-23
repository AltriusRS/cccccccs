#!/usr/bin/env bash
set -euo pipefail

echo "== OS =="
cat /etc/os-release

echo
echo "== Environment =="
echo "USER=${USER:-}"
echo "HOME=${HOME:-}"
echo "SHELL=${SHELL:-}"
echo "PWD=$(pwd)"
echo "RUNNER_TOOL_CACHE=${RUNNER_TOOL_CACHE:-}"
echo "AGENT_TOOLSDIRECTORY=${AGENT_TOOLSDIRECTORY:-}"
echo "GITHUB_WORKSPACE=${GITHUB_WORKSPACE:-}"
echo "ImageOS=${ImageOS:-}"
echo "ImageVersion=${ImageVersion:-}"

echo
echo "== Core tools =="
git --version
git lfs version
curl --version | head -n 1
wget --version | head -n 1
jq --version
yq --version
zip -v | head -n 1
unzip -v | head -n 1
tar --version | head -n 1
zstd --version | head -n 1

echo
echo "== Build tools =="
gcc --version | head -n 1
g++ --version | head -n 1
make --version | head -n 1
cmake --version | head -n 1
ninja --version
pkg-config --version

echo
echo "== Language runtimes =="
python3 --version
pip3 --version
node --version
npm --version
java --version
go version
rustc --version
cargo --version
bun --version

echo
echo "== DevOps / CI tools =="
gh --version | head -n 1
docker --version
docker compose version

echo
echo "== Misc tools =="
sqlite3 --version
shellcheck --version | head -n 1
ssh -V 2>&1
rsync --version | head -n 1

echo
echo "== Filesystem layout =="
test -d /workspace
test -d /opt/hostedtoolcache
echo "/workspace exists"
echo "/opt/hostedtoolcache exists"

echo
echo "== Runner user check =="
id runner

echo
echo "== Write test =="
tmpfile="$(mktemp)"
echo "ok" > "$tmpfile"
cat "$tmpfile"
rm -f "$tmpfile"

echo
echo "Smoke test passed."