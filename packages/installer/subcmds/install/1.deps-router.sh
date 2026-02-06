# This script is meant to be sourced.
# It's not for directly running.
printf "${STY_CYAN}[$0]: 1. Install dependencies\n${STY_RST}"

function outdate_detect(){
  # Shallow clone prevent latest_commit_timestamp() from working.
  x git_auto_unshallow 2>&1>/dev/null

  local source_path="$1"
  local target_path="$2"
  local source_timestamp="$(latest_commit_timestamp $source_path 2>/dev/null)"
  local target_timestamp="$(latest_commit_timestamp $target_path 2>/dev/null)"
  local outdate_detect_mode="$(cat ${target_path}/outdate-detect-mode)"

  # outdate-detect-mode possible modes:
  # - WIP: Work in progress (should be taken as outdated)
  # - FORCE_OUTDATED: forcely taken as outdated
  # - FORCE_UPDATED: forcely taken as updated
  # - AUTO: Let the script decide automatically
  #
  # outdate status possible values:
  # - WIP,FORCE_OUTDATED,FORCE_UPDATED: Inherited directly from outdate-detect-mode
  # - EMPTY_SOURCE: source path has empty timestamp, maybe not tracked by git (should be taken as outdated)
  # - EMPTY_TARGET: target path has empty timestamp, maybe not tracked by git (should be taken as outdated)
  # - OUTDATED: target path is older than source path.
  # - UPDATED: target path is not older than source path.

  # Does target path have an outdate-detect-mode file which content is special?
  if [[ "${outdate_detect_mode}" =~ ^(WIP|FORCE_OUTDATED|FORCE_UPDATED)$ ]]; then
    echo "${outdate_detect_mode}"
  # Does source path has an empty timestamp?
  elif [ -z "$source_timestamp" ]; then
    echo "EMPTY_SOURCE"
  # Does target path has an empty timestamp?
  elif [ -z "$target_timestamp" ]; then
    echo "EMPTY_TARGET"
  # If target path is older than source path, it's outdated.
  elif [[ "$target_timestamp" -lt "$source_timestamp" ]]; then
    echo "OUTDATED"
  else
    echo "UPDATED"
  fi
}
#####################################################################################

if [[ "$INSTALL_VIA_NIX" == "true" ]]; then

  TARGET_ID=nix
  printf "${STY_YELLOW}"
  printf "===WARNING===\n"
  printf "./packages/installer/distros/${TARGET_ID}/install-deps.sh will be used.\n"
  printf "The process is still WIP.\n"
  printf "Proceed only at your own risk.\n"
  printf "\n"
  printf "${STY_RST}"
  pause
  source ./packages/installer/distros/${TARGET_ID}/install-deps.sh

elif [[ "$OS_GROUP_ID" =~ ^(arch|gentoo|fedora)$ ]]; then

  TARGET_ID=$OS_GROUP_ID
  if ! [[ "${TARGET_ID}" = "arch" ]]; then
    tmp_update_status="$(outdate_detect packages/installer/distros/arch packages/installer/distros/${TARGET_ID})"
    if [[ "${tmp_update_status}" =~ ^(OUTDATED|EMPTY_TARGET|EMPTY_SOURCE|FORCE_OUTDATED|WIP)$ ]]; then
      printf "${STY_RED}${STY_BOLD}===URGENT===${STY_RST}\n"
      printf "${STY_RED}"
      printf "Status code: ${tmp_update_status}\n"
      printf "The community provided ./packages/installer/distros/${TARGET_ID}/ seems to be outdated,\n"
      printf "which means it probably does not reflect all latest changes of ./packages/installer/distros/arch/ .\n"
      printf "In such case it may work unexpectedly.${STY_RST}\n"
      printf "\n"
      printf "${STY_RED}It's highly recommended to check the following links before continue.${STY_RST}\n"
      printf "${STY_RED}1. Normally just check discussion#2140 to see if there's any valid update notice.${STY_RST}\n"
      printf "   ${STY_UNDERLINE}https://github.com/end-4/dots-hyprland/discussions/2140${STY_RST}\n"
      printf "   ${STY_RED}Note that the timeliness relies on manual maintenance.${STY_RST}\n"
      printf "${STY_RED}2. For details please compare the two lists of commit history:${STY_RST}\n"
      printf "   ${STY_UNDERLINE}https://github.com/0x0Dx/dotfiles/commits/main/packages/installer/distros/arch${STY_RST}\n"
      printf "   ${STY_UNDERLINE}https://github.com/0x0Dx/dotfiles/commits/main/packages/installer/distros/${TARGET_ID}${STY_RST}\n"
      printf "\n"
      printf "${STY_PURPLE}PR on ./packages/installer/distros/${TARGET_ID}/ to properly reflect the latest changes of ./packages/installer/distros/arch is welcomed.${STY_RST}\n"
      printf "${STY_PURPLE}${STY_BOLD}Again, do not create any issue,${STY_RST}\n"
      printf "${STY_PURPLE}but you can create a discussion under \"Extra Distros\" category: ${STY_RST}\n"
      printf "${STY_PURPLE}${STY_UNDERLINE}https://github.com/end-4/dots-hyprland/discussions/new?category=extra-distros${STY_RST}\n"
      printf "\n"
      if [[ "${tmp_update_status}" = "OUTDATED" ]]; then
        printf "${STY_RED}NOTE: The conclusion above is determined automatically by comparing latest Git commit time,\n"
        printf "however sometimes the changes on \"distros/arch\" are actually not needed for \"distros/${TARGET_ID}\",\n"
        printf "in such case you should just ignore it and continue.\n"
        printf "${STY_RST}\n"
      fi
      printf "\n"
      if ! [[ "$IGNORE_OUTDATE_CHECK" = "true" ]]; then
        if [ "$ask" = "false" ]; then
          printf "${STY_RED}Urgent problem encountered, aborting...${STY_RST}\n";exit 1
        else
          printf "${STY_RED}Still proceed?${STY_RST}\n"
          read -p "[y/N]: " p
          case "$p" in
            [yY])sleep 0;;
            *)echo "Aborting...";exit 1;;
          esac
        fi
      fi
    fi
  fi
  printf "./packages/installer/distros/${TARGET_ID}/install-deps.sh will be used.\n"
  source ./packages/installer/distros/${TARGET_ID}/install-deps.sh
fi
