#!/usr/bin/env bash

set -euxo pipefail

rm -rf results build

if command -v docker >/dev/null 2>&1; then
  builder=(docker build)
elif command -v podman >/dev/null 2>&1; then
  # Dockerfile contains a SHELL command needed across multi-stage images (required
  # by `. /emsdk/emsdk_env.sh`), however this is not part of the standard OCI format.
  # see: https://github.com/podman-container-tools/buildah/issues/6460
  builder=(podman build --format docker)
else
  echo "error: neither docker nor podman is available" >&2
  exit 127
fi

"${builder[@]}" --target test-output -o results .
"${builder[@]}" --target output -o build .
