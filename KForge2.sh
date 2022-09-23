#!/bin/bash
sudo apt -y build-dep phonon4qt5-backend-vlc phonon4qt5-backend-gstreamer breeze-gtk-theme kgamma5 xdg-desktop-portal-kde
sudo apt -y install libqca-qt5-2-dev libavcodec-dev libavutil-dev libavformat-dev libswscale-dev
CXX=/usr/bin/g++-10 kdesrc-build plasma-workspace plasma-framework plasma-integration bluedevil powerdevil plasma-nm plasma-pa plasma-thunderbolt plasma-vault plasma-firewall plasma-workspace-wallpapers kdeplasma-addons krunner milou kwin kscreen sddm-kcm plymouth-kcm breeze discover print-manager plasma-sdk kaccounts-integration kaccounts-providers kdeconnect-kde plasma-browser-integration xdg-desktop-portal-kde kde-gtk-config khotkeys kgamma5 breeze-gtk drkonqi phonon --include-dependencies
CXX=/usr/bin/g++-10 kdesrc-build plasma-desktop systemsettings ksysguard plasma-disks plasma-systemmonitor ksystemstats kinfocenter kmenuedit --include-dependencies
~/kde/build/plasma-workspace/login-sessions/install-sessions.sh
