#!/usr/bin/env bash
set -e

FONT_DIR="/usr/share/fonts"
TMP_DIR=$(mktemp -d)

echo "Installing fonts to $FONT_DIR"

declare -A FONTS
FONTS["FiraCode"]="https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip"
FONTS["Fira_Sans"]="https://github.com/mozilla/Fira/archive/refs/heads/master.zip"
FONTS["BebasNeue-Regular"]="https://github.com/dharmatype/Bebas-Neue/raw/master/BebasNeue-Regular.ttf"
FONTS["Material-Icons"]="https://github.com/google/material-design-icons/archive/refs/heads/master.zip"

for FONT in "${!FONTS[@]}"; do
    URL="${FONTS[$FONT]}"
    echo "Installing $FONT from $URL ..."

    FILE="$TMP_DIR/${FONT}.zip"

    curl -L -o "$FILE" "$URL" || wget -O "$FILE" "$URL"

    if [[ "$FILE" == *.zip ]]; then
        unzip -q "$FILE" -d "$TMP_DIR/$FONT"
        sudo cp -rf "$TMP_DIR/$FONT"/* "$FONT_DIR/"
    else
        sudo cp -f "$FILE" "$FONT_DIR/"
    fi
done

sudo fc-cache -f -v
rm -rf "$TMP_DIR"

echo "Fonts installed successfully!"
