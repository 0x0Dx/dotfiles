#!/usr/bin/env bash
set -e

MATUGEN_VERSION="v2.4.1"
INSTALL_DIR="$HOME/.local/bin"
URL="https://github.com/InioX/matugen/releases/download/${MATUGEN_VERSION}/matugen"

echo "Installing Matugen ${MATUGEN_VERSION} into ${INSTALL_DIR}"

mkdir -p "$INSTALL_DIR"
curl -L -o "$INSTALL_DIR/matugen" "$URL"
chmod +x "$INSTALL_DIR/matugen"

echo "Matugen ${MATUGEN_VERSION} installed successfully!"
