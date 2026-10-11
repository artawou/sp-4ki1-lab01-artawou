#!/usr/bin/env bash
set -euo pipefail

NAME="vtfk-lab01"

# Idempotency: remove a container left by an earlier run.
docker rm -f "$NAME" >/dev/null 2>&1 || true

: "${VTFK_NONCE:?VTFK_NONCE must be set by the grader}"

# Keep a long-running process as PID 1 and pass the grader's nonce into the container.
docker run -d \
  --name "$NAME" \
  --env "VTFK_NONCE=$VTFK_NONCE" \
  ubuntu:24.04 \
  sleep infinity >/dev/null

# The minimal Ubuntu image does not include ps; install it before measuring processes.
if ! docker exec "$NAME" bash -c \
  'apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq procps >/dev/null'; then
  echo "Failed to install procps in the container." >&2
  exit 1
fi

# Write the nonce from the container's environment into the required file.
docker exec "$NAME" bash -c 'printf "%s" "$VTFK_NONCE" > /tmp/vtfk-nonce'

CONTAINER_PID="$(docker exec "$NAME" awk '/^Pid:/ {print $2; exit}' /proc/1/status | tr -d '[:space:]')"
CONTAINER_PROCS="$(docker exec "$NAME" ps aux | wc -l | tr -d '[:space:]')"
HOST_PROCS="$(ps aux | wc -l | tr -d '[:space:]')"

printf 'CONTAINER_PID=%s\n' "$CONTAINER_PID"
printf 'CONTAINER_PROCS=%s\n' "$CONTAINER_PROCS"
printf 'HOST_PROCS=%s\n' "$HOST_PROCS"
