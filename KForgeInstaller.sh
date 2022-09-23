#!/bin/bash
# KForge Installer Script
sudo apt install -y git cmake dialog
mkdir -p ~/kde/src
cd ~/kde/src/
git clone https://invent.kde.org/sdk/kdesrc-build.git && cd kdesrc-build
./kdesrc-build --initial-setup
source ~/.bashrc
sudo apt update
sudo apt -y full-upgrade
sudo apt -y build-dep plasma-desktop plasma-workspace kwin phonon4qt5-backend-vlc phonon4qt5-backend-gstreamer breeze-gtk-theme kgamma5 xdg-desktop-portal-kde
sudo apt -y install libqca-qt5-2-dev libavcodec-dev libavutil-dev libavformat-dev libswscale-dev
reboot
