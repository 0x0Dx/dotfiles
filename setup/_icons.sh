#!/usr/bin/env bash
set -e

ICON_REPO="https://github.com/vinceliuice/Colloid-icon-theme"
INSTALL_DIR="$HOME/.local/share/icons"

echo "Installing Colloid icon theme from GitHub into ${INSTALL_DIR}"

for ICON in Colloid Colloid-Dark Colloid-Light; do
    if [ -d "${INSTALL_DIR}/${ICON}" ]; then
        rm -rf "${INSTALL_DIR}/${ICON}"
    fi
done

API_URL="https://api.github.com/repos/vinceliuice/Colloid-icon-theme/releases/latest"
TARBALL_URL=$(curl -s "$API_URL" | grep "browser_download_url" | grep ".tar.xz" | cut -d '"' -f 4)

if [ -z "$TARBALL_URL" ]; then
    echo "Could not find tarball URL — aborting." >&2
    exit 1
fi

mkdir -p "$INSTALL_DIR"
curl -L -o "$INSTALL_DIR/colloid-icons.tar.xz" "$TARBALL_URL"
tar -xf "$INSTALL_DIR/colloid-icons.tar.xz" -C "$INSTALL_DIR"
rm "$INSTALL_DIR/colloid-icons.tar.xz"

if [ -d "$INSTALL_DIR/Colloid/actions" ]; then
    rm -rf "$INSTALL_DIR/Colloid/actions"
fi

if [ -f "$INSTALL_DIR/Colloid/actions@2x" ]; then
    rm "$INSTALL_DIR/Colloid/actions@2x"
fi

echo "Colloid icons installed successfully!"
