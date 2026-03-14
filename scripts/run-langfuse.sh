#!/usr/bin/env bash
set -euo pipefail

# This script runs Langfuse using the container CLI available on your machine.
# Rancher Desktop can expose either Docker CLI (moby) or nerdctl (containerd).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LANGFUSE_DIR="$ROOT_DIR/langfuse"

if [ ! -d "$LANGFUSE_DIR" ]; then
  echo "Missing $LANGFUSE_DIR. Run ./scripts/pull-langfuse.sh first." >&2
  exit 1
fi

if command -v docker >/dev/null 2>&1; then
  if docker compose version >/dev/null 2>&1; then
    echo "Using Docker CLI (moby) with docker compose."
    (cd "$LANGFUSE_DIR" && docker compose up)
    exit 0
  fi
fi

if command -v nerdctl >/dev/null 2>&1; then
  echo "Using nerdctl (containerd) with nerdctl compose."
  (cd "$LANGFUSE_DIR" && nerdctl compose up)
  exit 0
fi

cat <<'MSG' >&2
No compatible container CLI found.
- If you're using Rancher Desktop, ensure it is running.
- For moby, enable Docker CLI and use `docker compose`.
- For containerd, use `nerdctl compose`.
MSG
exit 1
