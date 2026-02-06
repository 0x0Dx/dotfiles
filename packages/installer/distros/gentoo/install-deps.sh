printf "${STY_YELLOW}"
printf "============WARNING/NOTE (1)============\n"
printf "Ensure you have a global use flag for elogind or systemd in your make.conf for simplicity\n"
printf "Or you can manually add the use flags for each package that requires it\n"
printf "${STY_RST}"
pause

printf "${STY_YELLOW}"
printf "============WARNING/NOTE (2)============\n"
printf "https://github.com/0x0Dx/dotfiles/blob/main/packages/installer/distros/gentoo/README.md\n"
printf "Checkout the above README for potential bug fixes or additional information\n\n"
printf "${STY_RST}"
pause

x sudo emerge --update --quiet app-eselect/eselect-repository
x sudo emerge --update --quiet app-portage/smart-live-rebuild
# Currently using 3.12 python, this doesn't need to be default though
x sudo emerge --update --quiet dev-lang/python:3.12

if [[ -z $(eselect repository list | grep daifuku) ]]; then
	v sudo eselect repository create daifuku
	v sudo eselect repository enable daifuku
fi

if [[ -z $(eselect repository list | grep -E ".*guru \*.*") ]]; then
        v sudo eselect repository enable guru
fi

if [[ -z $(eselect repository list | grep -E ".*hyproverlay \*.*") ]]; then
	v sudo eselect repository enable hyproverlay
fi

arch=$(portageq envvar ACCEPT_KEYWORDS)

# Exclude hyprland, will deal with that separately
metapkgs=(daifuku-{audio,backlight,basic,bibata-modern-classic-bin,fonts-themes,hyprland,kde,microtex-git,oneui4-icons-git,portal,python,quickshell-git,screencapture,toolkit,widgets})

ebuild_dir="/var/db/repos/daifuku"


########## IMPORT KEYWORDS (START)
# daifuku
x sudo cp ./packages/installer/distros/gentoo/keywords ./packages/installer/distros/gentoo/keywords-user
x sed -i "s/$/ ~${arch}/" ./packages/installer/distros/gentoo/keywords-user
v sudo cp ./packages/installer/distros/gentoo/keywords-user /etc/portage/package.accept_keywords/daifuku

########## IMPORT USEFLAGS
v sudo cp ./packages/installer/distros/gentoo/useflags /etc/portage/package.use/daifuku
v sudo sh -c 'cat ./packages/installer/distros/gentoo/additional-useflags >> /etc/portage/package.use/daifuku'

########## UPDATE SYSTEM
v sudo emerge --sync
v sudo emerge --quiet --newuse --update --deep @world
v sudo emerge --quiet @smart-live-rebuild
v sudo emerge --depclean

# Remove old ebuilds (if this isn't done the wildcard will fuck upon a version change)
x sudo rm -fr ${ebuild_dir}/app-misc/daifuku-*

source ./packages/installer/distros/gentoo/import-local-pkgs.sh

########## INSTALL ILLOGICAL-IMPUSEL EBUILDS
for i in "${metapkgs[@]}"; do
	x sudo mkdir -p ${ebuild_dir}/app-misc/${i}
	v sudo cp ./packages/installer/distros/gentoo/${i}/${i}*.ebuild ${ebuild_dir}/app-misc/${i}/
	v sudo ebuild ${ebuild_dir}/app-misc/${i}/*.ebuild digest
	v sudo emerge --update --quiet app-misc/${i}
done
