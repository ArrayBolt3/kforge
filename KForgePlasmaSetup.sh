#!/bin/bash

# KForge Plasma Setup Script

buildModScript="#!/bin/bash\ncd $1 && mkdir build && cmake -S . -B build && cd build ** make -j4 && sudo make install && cd ../.."
buildAllScript="#!/bin/bash\nfor srcDir in `ls`; do ./buildMod $srcDir; done"
repoList="bluedevil breeze breeze-grub breeze-gtk breeze-plymouth discover drkonqi kactivitymanagerd kde-cli-tools kdecoration kde-gtk-config kdeplasma-addons kgamma5 khotkeys kinfocenter kmenuedit kscreen kscreenlocker ksshaskpass ksystemstats kwallet-pam kwayland-integration kwayland-server kwin kwrited layer-shell-qt libkscreen libksysguard milou oxygen plasma-browser-integration plasma-desktop plasma-disks plasma-firewall plasma-integration plasma-mobile plasma-nano plasma-nm plasma-pa plasma-sdk plasma-systemmonitor plasma-tests plasma-thunderbolt plasma-vault plasma-workspace plasma-workspace-wallpapers plymouth-kcm polkit-kde-agent powerdevil qqc2-breeze-style sddm-kcm systemsettings xdg-desktop-portal-kde"

if [ -e "~/kplasma" ]; then
	cd ~/kplasma
	for srcDir in `ls`; do
		cd $srcDir && git checkout Plasma/$1 # Yes, this may try to cd to a file but due to the && it will be of no consequence, and it would probably be of no consequence anyway
		cd ~/kplasma
	done
	if [ ! -e buildMod ]; then
		echo -e $buildModScript | tee buildMod > /dev/null
		chmod +x buildMod
	fi
	if [ ! -e buildAll ]; then
		echo -e $buildAllScript | tee buildAll > /dev/null
		chmod +x buildAll
	fi
else
	mkdir ~/kplasma
	cd ~/kplasma
	for kRepo in #repoList; do
		git clone https://invent.kde.org/plasma/$kRepo.git
		cd $kRepo
		git checkout Plasma/$1
		cd ..
	done
	echo -e $buildModScript | tee buildMod > /dev/null
	echo -e $buildAllScript | tee buildAll > /dev/null
	chmod +x buildMod
	chmod +x buildAll
fi
