# This script is meant to be sourced.
# It's not for directly running.

# shellcheck shell=bash

#####################################################################################
# MISC (For packages/dotfiles/.config/* but not quickshell, not fish, not Hyprland, not fontconfig)
case "${SKIP_MISCCONF}" in
  true) sleep 0;;
  *)
    for i in $(find packages/dotfiles/.config/ -mindepth 1 -maxdepth 1 ! -name 'quickshell' ! -name 'fish' ! -name 'hypr' ! -name 'fontconfig' -exec basename {} \;); do
#      i="packages/dotfiles/.config/$i"
      echo "[$0]: Found target: packages/dotfiles/.config/$i"
      if [ -d "packages/dotfiles/.config/$i" ];then install_dir__sync "packages/dotfiles/.config/$i" "$XDG_CONFIG_HOME/$i"
      elif [ -f "packages/dotfiles/.config/$i" ];then install_file "packages/dotfiles/.config/$i" "$XDG_CONFIG_HOME/$i"
      fi
    done
    install_dir "packages/dotfiles/.local/share/konsole" "${XDG_DATA_HOME}"/konsole
    ;;
esac

case "${SKIP_QUICKSHELL}" in
  true) sleep 0;;
  *)
     # Should overwriting the whole directory not only ~/.config/quickshell/daifuku/ cuz https://github.com/end-4/dots-hyprland/issues/2294#issuecomment-3448671064
    install_dir__sync quickshell "$XDG_CONFIG_HOME"/quickshell/daifuku
    ;;
esac

case "${SKIP_FISH}" in
  true) sleep 0;;
  *)
    install_dir__sync_exclude packages/dotfiles/.config/fish "$XDG_CONFIG_HOME"/fish "conf.d"
    ;;
esac

case "${SKIP_FONTCONFIG}" in
  true) sleep 0;;
  *)
    case "$FONTSET_DIR_NAME" in
      "") install_dir__sync packages/dotfiles/.config/fontconfig "$XDG_CONFIG_HOME"/fontconfig ;;
      *) install_dir__sync packages/dotfiles/extra/fontsets/$FONTSET_DIR_NAME "$XDG_CONFIG_HOME"/fontconfig ;;
    esac;;
esac

# For Hyprland
case "${SKIP_HYPRLAND}" in
  true) sleep 0;;
  *)
    install_dir__sync packages/dotfiles/.config/hypr/hyprland "$XDG_CONFIG_HOME"/hypr/hyprland
    for i in hypr{land,lock}.conf {monitors,workspaces}.conf ; do
      install_file__auto_backup "packages/dotfiles/.config/hypr/$i" "${XDG_CONFIG_HOME}/hypr/$i"
    done
    for i in hypridle.conf ; do
      if [[ "${INSTALL_VIA_NIX}" == true ]]; then
        install_file__auto_backup "packages/dotfiles/extra/via-nix/$i" "${XDG_CONFIG_HOME}/hypr/$i"
      else
        install_file__auto_backup "packages/dotfiles/.config/hypr/$i" "${XDG_CONFIG_HOME}/hypr/$i"
      fi
    done
    if [ "$OS_GROUP_ID" = "fedora" ];then
      v bash -c "printf \"# For fedora to setup polkit\nexec-once = /usr/libexec/kf6/polkit-kde-authentication-agent-1\n\" >> ${XDG_CONFIG_HOME}/hypr/hyprland/execs.conf"
    fi

    install_dir__skip_existed "packages/dotfiles/.config/hypr/custom" "${XDG_CONFIG_HOME}/hypr/custom"
    ;;
esac

install_file "packages/dotfiles/.local/share/icons/illogical-impulse.svg" "${XDG_DATA_HOME}"/icons/illogical-impulse.svg
