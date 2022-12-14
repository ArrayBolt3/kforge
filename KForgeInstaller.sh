#!/bin/bash
# KForge Installer Script
sudo apt update
sudo apt -y full-upgrade
sudo apt install -y git cmake dialog
echo "ALL            ALL = (ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/nopwdsudo
mkdir -p ~/kde/src
cd ~/kde/src/
git clone https://invent.kde.org/sdk/kdesrc-build.git && cd kdesrc-build
./kdesrc-build --initial-setup
source ~/.bashrc
sudo apt -y build-dep plasma-desktop plasma-workspace kwin phonon4qt5-backend-vlc phonon4qt5-backend-gstreamer breeze-gtk-theme kgamma5 xdg-desktop-portal-kde kaccounts-integration akonadi-server libkscreenlocker5 okular kitinerary kdepim-runtime gwenview kamera kdevelop lokalize kstars minuet kmousetool krfb ark kio-audiocd ffmpegthumbs k3b kwave kajongg kpat signon-kwallet-extension kidletime ktp-common-internals
sudo apt -y install libplymouth-dev xsdcxx libsensors4-dev libnl-cli-3-dev libnl-genl-3-dev libnl-idiag-3-dev libnl-nf-3-dev libnl-xfrm-3-dev
tee << EOF > ~/.config/kdesrc-buildrc
# This file controls options to apply when configuring/building modules, and
# controls which modules are built in the first place.
# List of all options: https://docs.kde.org/trunk5/en/kdesrc-build/kdesrc-build/conf-options-table.html

global

    # Finds and includes *KDE*-based dependencies into the build.  This makes
    # it easier to ensure that you have all the modules needed, but the
    # dependencies are not very fine-grained so this can result in quite a few
    # modules being installed that you didn't need.
    include-dependencies true

    # Install directory for KDE software
    kdedir /usr

    # Directory for downloaded source code
    source-dir ~/kde/src

    # Directory to build KDE into before installing
    # relative to source-dir by default
    build-dir ~/kde/build

#   qtdir  ~/kde/qt5 # Where to install Qt5 if kdesrc-build supplies it

    cmake-options -DCMAKE_BUILD_TYPE=RelWithDebInfo

    # kdesrc-build sets 2 options which is used in options like make-options or set-env
    # to help manage the number of compile jobs that happen during a build:
    #
    # 1. num-cores, which is just the number of detected CPU cores, and can be passed
    #    to tools like make (needed for parallel build) or ninja (completely optional).
    #
    # 2. num-cores-low-mem, which is set to largest value that appears safe for
    #    particularly heavyweight modules based on total memory, intended for
    #    modules like qtwebengine
    num-cores 4
    num-cores-low-mem 4

    # kdesrc-build can install a sample .xsession file for "Custom"
    # (or "XSession") logins,
    install-session-driver false

    # or add a environment variable-setting script to
    # ~/.config/kde-env-master.sh
    install-environment-driver true

    # Stop the build process on the first failure
    stop-on-failure true

    # Use a flat folder layout under ~/kde/src and ~/kde/build
    # rather than nested directories
    directory-layout flat

    # Build with LSP support for everything that supports it
    compile-commands-linking true
    compile-commands-export true

    # Use sudo for installation
    make-install-prefix sudo
end global

# With base options set, the remainder of the file is used to define modules to build, in the
# desired order, and set any module-specific options.
#
# Modules may be grouped into sets, and this is the normal practice.
#
# You can include other files inline using the "include" command. We do this here
# to include files which are updated with kdesrc-build.

# Common options that should be set for some KDE modules no matter how
# kdesrc-build finds them. Do not comment these out unless you know
# what you are doing.
include /home/$USER/kde/src/kdesrc-build/kf5-common-options-build-include

# Qt and some Qt-using middleware libraries. Uncomment if your distribution's Qt
# tools are too old but be warned that Qt take a long time to build!
#include /home/$USER/kde/src/kdesrc-build/qt5-build-include
#include /home/$USER/kde/src/kdesrc-build/custom-qt5-libs-build-include

# KF5 and Plasma :)
include /home/$USER/kde/src/kdesrc-build/kf5-qt5-build-include

# To change options for modules that have already been defined, use an
# 'options' block. See kf5-common-options-build-include for an example
EOF
tee << EOF > ~/.config/baloofilerc
[Basic Settings]
Indexing-Enabled=true

[General]
dbVersion=2
exclude filters=*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,core-dumps,lost+found
exclude filters version=8
exclude folders[\$e]=\$HOME/kde/,$HOME/kplasma/
EOF
reboot
