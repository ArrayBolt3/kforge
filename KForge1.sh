#!/bin/bash
# KForge Prep Stage 1
sudo apt install -y git cmake dialog
mkdir -p ~/kde/src
cd ~/kde/src/
git clone https://invent.kde.org/sdk/kdesrc-build.git && cd kdesrc-build
./kdesrc-build --initial-setup
source ~/.bashrc
sudo apt update
sudo apt -y full-upgrade
sudo apt -y build-dep plasma-desktop plasma-workspace kwin
reboot
