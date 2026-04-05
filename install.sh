#!/usr/bin/env bash
# project-manager install script
# Installs the `proj` CLI to ~/.local/bin/
#
# Usage (remote):
#   bash <(curl -fsSL https://raw.githubusercontent.com/dnewcome/techno-forge/main/project-manager/install.sh)
#
# Usage (local, from project-manager/ or repo root):
#   bash project-manager/install.sh
#   bash install.sh

set -euo pipefail

REPO="https://github.com/dnewcome/techno-forge"
TAG="main"
INSTALL_DIR="$HOME/.local/bin"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag) TAG="$2"; shift 2 ;;
    --dir) INSTALL_DIR="$2"; shift 2 ;;
    *) echo "Unknown argument: $1"; exit 1 ;;
  esac
done

# Require Python 3.11+ for tomllib
PYTHON=$(command -v python3 || true)
if [[ -z "$PYTHON" ]]; then
  echo "Error: python3 not found" >&2
  exit 1
fi
PY_VERSION=$("$PYTHON" -c 'import sys; print(f"{sys.version_info.major}{sys.version_info.minor:02d}")')
if (( PY_VERSION < 311 )); then
  echo "Error: Python 3.11+ required (found $("$PYTHON" --version))" >&2
  exit 1
fi

mkdir -p "$INSTALL_DIR"

# If running from the local repo, copy directly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/proj" ]]; then
  echo "Installing proj from local source..."
  cp "$SCRIPT_DIR/proj" "$INSTALL_DIR/proj"
else
  echo "Installing proj@${TAG} from GitHub..."
  TMP=$(mktemp -d)
  trap 'rm -rf "$TMP"' EXIT

  if [[ "$TAG" == "main" ]]; then
    TARBALL_URL="$REPO/archive/refs/heads/main.tar.gz"
  else
    TARBALL_URL="$REPO/archive/refs/tags/${TAG}.tar.gz"
  fi

  echo "  Fetching $TARBALL_URL..."
  curl -fsSL "$TARBALL_URL" | tar xz -C "$TMP"
  SRC=$(ls "$TMP")
  cp "$TMP/$SRC/project-manager/proj" "$INSTALL_DIR/proj"
fi

chmod +x "$INSTALL_DIR/proj"
echo "  Installed $INSTALL_DIR/proj"

if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
  echo ""
  echo "Note: $INSTALL_DIR is not on your PATH. Add to your shell config:"
  echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
fi

echo ""
echo "Done. Try: proj ls --recent 10"
