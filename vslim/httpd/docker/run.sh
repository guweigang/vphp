#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
IMAGE="${VHTTPD_DOCKER_IMAGE:-vhttpd-dev:latest}"
CONFIG_IN_CONTAINER="${VHTTPD_CONFIG_IN_CONTAINER:-/app/vslim/httpd/docker/config/hello.toml}"

cd "$ROOT"

docker build -t "$IMAGE" -f "$ROOT/vslim/httpd/docker/Dockerfile" .

docker run --rm \
  -p 19881:19881 \
  -p 19981:19981 \
  "$IMAGE" \
  /app/vslim/httpd/vhttpd --config "$CONFIG_IN_CONTAINER"
