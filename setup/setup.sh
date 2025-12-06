#!/usr/bin/env bash
sleep 1

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --------------------------------------------------------------
# Library
# --------------------------------------------------------------

source $SCRIPT_DIR/_lib.sh

# ----------------------------------------------------------
# Detect distribution
# ----------------------------------------------------------

_selectDistribution() {

# ----------------------------------------------------------
# Header
# ----------------------------------------------------------

clear
echo -e "${GREEN}"
cat <<"EOF"
   ____    __          
  / __/__ / /___ _____ 
 _\ \/ -_) __/ // / _ \
/___/\__/\__/\_,_/ .__/
                /_/    
ML4W Hyprland Starter

EOF
    echo -e "${NONE}"
    
    echo ":: Distribution could not be auto detected. Please select your base distribution."
    echo 
    echo "1: Arch (pacman + aur helper)"
    echo "2: Fedora (dnf)"
    echo "3: OpenSuse (zypper)"
    echo "4: Show dependencies and install manually for your distribution"
    echo "5: Cancel"
    echo 
    while true; do
        read -p "Please select: " yn
        case $yn in
            1)
                $SCRIPT_DIR/setup-arch.sh
                break
                ;;
            2)
                $SCRIPT_DIR/setup-fedora.sh
                break
                ;;
            3)
                $SCRIPT_DIR/setup-opensuse.sh
                break
                ;;
            4)
                $SCRIPT_DIR/dependencies.sh
                break
                ;;
            5)
                echo ":: Installation canceled"
                exit
                break
                ;;
            *)
                echo ":: Please select a valid option."
                ;;
        esac
    done    
    }

if [[ $(_checkCommandExists "pacman") == 0 ]]; then
    $SCRIPT_DIR/setup-arch.sh
elif [[ $(_checkCommandExists "dnf") == 0 ]]; then
    $SCRIPT_DIR/setup-fedora.sh
elif [[ $(_checkCommandExists "zypper") == 0 ]]; then
    $SCRIPT_DIR/setup-opensuse.sh
else
    $SCRIPT_DIR/dependencies.sh
fi

DOTFILES_REPO="https://github.com/0x0Dx/dotfiles.git"
TMP_DIR=$(mktemp -d)

echo ":: Fetching dotfiles from $DOTFILES_REPO ..."
git clone --depth 1 "$DOTFILES_REPO" "$TMP_DIR"

echo ":: Copying files to home directory ..."
cp -rf "$TMP_DIR/dotfiles/." "$HOME/"
rm -rf "$TMP_DIR"

echo ":: Dotfiles installation complete!"