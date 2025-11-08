#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"
TARGET="$HOME"

copy() {
    src="$DOTFILES/$1"
    dest="$TARGET/$2"

    if [ ! -e "$src" ]; then
        echo "❌ Source missing: $src"
        return
    fi

    echo "📦 Copying $src → $dest"
    rm -rf "$dest"
    mkdir -p "$(dirname "$dest")"

    if [ -d "$src" ]; then
        cp -rT "$src" "$dest"
    else
        cp -f "$src" "$dest"
    fi
}

copy ".config/tmux/tmux.conf" ".tmux.conf"
copy ".config/git/.gitconfig" ".gitconfig"
copy ".config/git/.gitignore_global" ".gitignore_global"
copy ".config/fastfetch/config.jsonc" ".config/fastfetch/config.jsonc"
copy ".zshrc" ".zshrc"
copy ".p10k.zsh" ".p10k.zsh"

echo "✅ All dotfiles copied and overwritten."
