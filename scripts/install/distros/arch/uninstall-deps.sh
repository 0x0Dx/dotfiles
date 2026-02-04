# shellcheck disable=SC2148

for i in daifuku-{quickshell-git,audio,backlight,basic,bibata-modern-classic-bin,fonts-themes,hyprland,kde,microtex-git,oneui4-icons-git,portal,python,screencapture,toolkit,widgets} plasma-browser-integration; do
  v yay -Rns $i
done
