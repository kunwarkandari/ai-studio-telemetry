#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_URL="https://github.com/langfuse/langfuse.git"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

if command -v git >/dev/null 2>&1; then
  git clone --depth 1 "$UPSTREAM_URL" "$TMP_DIR/langfuse"
else
  echo "git is required to pull Langfuse." >&2
  exit 1
fi

# Replace the tracked copy so the repo contains the latest upstream code.
rm -rf "$ROOT_DIR/langfuse"
mkdir -p "$ROOT_DIR/langfuse"

if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete --exclude ".git" "$TMP_DIR/langfuse/" "$ROOT_DIR/langfuse/"
else
  # Fallback without rsync. This does not preserve deletions from upstream.
  cp -a "$TMP_DIR/langfuse/." "$ROOT_DIR/langfuse/"
  rm -rf "$ROOT_DIR/langfuse/.git"
fi

rm -rf "$ROOT_DIR/langfuse/.git"

echo "Langfuse pulled into $ROOT_DIR/langfuse"
