# KForge

## The (hopefully) Ultimate KDE Build Environment

KForge is a virtual machine appliance running a customized version of KDE neon Developer Edition, designed to be ready for developing KDE and its applications from the word "Go". While KDE neon Developer Edition comes with extra components to make building KDE software easier, KForge comes with a full suite of KDE development tools preinstalled and ready to be used. The entire source code of KDE Plasma is preloaded onto the VM, and even built into binaries, making it so that you can get started hacking at the code almost immediately.

KForge comes in two variants - the virtual machine disk image itself, and a pair of setup scripts that can be ran on a KDE neon Developer Edition VM to turn it into KForge. The VM disk image can be imported into virt-manager or GNOME Boxes, or you can convert it to a VirtualBox disk image and run it there. It's most useful for people who have Internet connections that work faster than their computers. The scripts take a long time to run and require a lot of computing power, but theoretically use less network bandwidth than the preinstalled VM, and are therefore better for people with fast computers and slower Internet connections. (Of course, if you happen to be blessed with both a fast computer and a fast Internet connection, then you can use either one.)

Due to GitHub's file size limitations, the full VM image has been compressed using LZ4, and then split into 1.8 GiB chunks. Since downloading, concatenating, and decompressing these chunks can be somewhat of an ordeal, there's also a download script included with KForge that will automatically do the whole job for you and leave you with the finished disk image.

## Disclaimers

This is a developer tool. As such, it is designed for people who mostly know what they're doing. These instructions don't clearly spell out all the possible "gotchas" (like being dreadfully careful with the terrifying `rm -rf` command). Since the whole entire system is designed to build and run alpha-quality and pre-alpha-quality code, there are almost certainly many bugs all through this.

If you don't know what you're doing, or if you don't clearly understand **everything** you read in this guide, **DO NOT USE THIS TOOL OR RUN ANY COMMANDS IN THIS GUIDE.** Running some of these commands in the wrong context could have unintended (and possibly catastrophic) results. Using the tool as a general-purpose operating system is likely to turn out disappointing. If you know what you're doing, none of this will deter you in the slightest. But if reading this gives you second thoughts, listen to them. Turn back now!

For those who are still with me, proceed.

## Getting KForge

### Downloading the VM

NOTE: The VM has not yet been uploaded. If you're reading this, skip ahead to the "Using the prep scripts" section.

1. Clone the KForge repository to your physical machine with `git clone https://github.com/ArrayBolt3/KForge.git`.
2. Open a terminal in the KForge folder created when you did the clone.
3. Run `./KForgeDL.sh`, and wait. It may take a while, especially if your connection is less than speedy, as the full VM image is very big, and has to be downloaded, fused together, and decompressed. When the command finishes, you will be left with a file named "KForge.qcow2" in your Downloads folder.
4. (For VirtualBox users) Run `qemu-img convert -O vdi KForge.qcow2 KForge.vdi` to convert the qcow2 image to a VirtualBox-compatible .vdi file. (Note that you will need QEMU installed to do this.)
5. Import the disk image into your virtualization software of choice. **It is highly recommended that you provide the VM with at least 8 GiB of RAM.**
6. Log into the VM. The username is "KForge", the password is a single lowercase "z".
7. Once the VM is up and running, log in open a terminal inside the VM and run `sudo apt update && sudo apt -y full-upgrade`.
8. Finally, run `CXX=/usr/bin/g++-10 kdesrc-build <kdecomponent>`, replacing `<kdecomponent>` with the name of the KDE component you want to start work on. This will update the source code for this KDE component and rebuild it, preparing it for use.

That's it! You're now ready to begin development.

### Using the prep scripts

1. Download KDE neon Developer Edition from here: https://files.kde.org/neon/images/developer/current/ Make sure to download the sha256sum file (or the .sig file if you want to be really cautious) and use it to verify the ISO file before creating a VM with it.
2. Using your virtualization software of choice, create a KDE neon VM. **It is highly recommended that you provide the VM with at least 8 GiB of RAM and 128 GiB of disk space.**
3. Once you have installed KDE neon, clone the KForge repository to your virtual machine with `git clone https://github.com/ArrayBolt3/KForge.git`.
4. Run `cd KForge && ./KForge1.sh`. You will be asked for the VMs password, possibly multiple times, depending on how long it takes for the first stage of VM preparation to finish. You will also have to press "y" at least once during the setup, so it's not fully unattended (yet). When the first stage of VM preparation has finished, the VM will automatically reboot.
5. When the VM finishes rebooting, log in, open System Settings, search for "File" and open "File Search". Then exclude the ~/kde directory from file indexing.
6. Open a terminal in the KForge directory, and run `./KForge2.sh`. This script will take a *while* to finish, as it installs build dependencies, and then clones and builds KDE Plasma. Depending on the speed of your machine, it may be some hours before the build finishes. You will again be asked for your VM password, probably at least twice.
7. When the script finishes, log out of KDE Plasma. In the list of sessions, you should now see an option to boot into your development build of Plasma. Log in to one of these sessions to verify that everything is working right.

If all goes as planned, you're done!

## Using KForge

The KDE source code is stored in a number of folders under ~/kde/src. Each KDE component has a folder containing its code and files. For instance, if you want to edit the source code for KWin, you go to ~/kde/src/kwin, and find the file you want to work on.

Once you've made your changes, the build process is managed by kdesrc-build. Since KDE neon is still based on Ubuntu 20.04, the default compiler is GCC 9, which isn't new enough to build all components of KDE (most notably I found KWin failed to build with GCC 9). However, GCC 10 is also installed. To ensure that everything builds properly, you currently need to specifically tell CMake (the build system kdesrc-build wields behind the scenes) to use GCC 10. To do this, any time you run kdesrc-build, you should run it as `CXX=/usr/bin/g++-10 kdesrc-build <options>`. There may be a way to set GCC 10 as the default compiler for CMake, but currently this isn't implemented. (Probably a simple variable export in .bashrc will do the trick, though I haven't tested this and my Bash skills aren't sufficiently up to par for me to know if that will work.)

Documentation on how to use kdesrc-build is here: https://docs.kde.org/trunk5/en/kdesrc-build/kdesrc-build/index.html Some quick commands that will come in handy:

* To rebuild a project quickly for testing a change you just made: `CXX=/usr/bin/g++-10 kdesrc-build --no-src --no-include-dependencies <kdecomponent>`
* To update the source of a component and fully rebuild it and stuff it depends on: `CXX=/usr/bin/g++-10 kdesrc-build <kdecomponent>`
* To discard any changes you've made to a component and rebuild it "clean": `rm -rf ~/kde/src/<kdecomponent> && CXX=/usr/bin/g++-10 kdesrc-build <kdecomponent>`
* To scrap EVERYTHING and start from scratch (useful for if you get your stuff really scrambled, like if your computer crashes mid-build):
    mv ~/kde/src/kdesrc-build ~/kdesrc-build-bak
    rm -rf ~/kde
    mkdir -p ~/kde/src
    mv ~/kdesrc-build-bak ~/kde/src/kdesrc-build
    kdesrc-build --initial-setup                    # When asked to update your .bashrc, answer "n", since it's already been updated once
    CXX=/usr/bin/g++-10 kdesrc-build plasma-workspace plasma-framework plasma-integration bluedevil powerdevil plasma-nm plasma-pa plasma-thunderbolt plasma-vault plasma-firewall plasma-workspace-wallpapers kdeplasma-addons krunner milou kwin kscreen sddm-kcm plymouth-kcm breeze discover print-manager plasma-sdk kaccounts-integration kaccounts-providers kdeconnect-kde plasma-browser-integration xdg-desktop-portal-kde kde-gtk-config khotkeys kgamma5 breeze-gtk drkonqi phonon --include-dependencies
    CXX=/usr/bin/g++-10 kdesrc-build plasma-desktop systemsettings ksysguard plasma-disks plasma-systemmonitor ksystemstats kinfocenter kmenuedit --include-dependencies

## License and Copyright Info

Copyright (c) 2022 Aaron Rainbolt.

The KForge VM is a conglomerate of software under various different licensing terms. Each application is offered under the license terms specified for it.

The files in the KForge Git repository (namely, this file and the accompanying scripts) are licensed under the GNU General Public License, either version 2 of the license, or (at your option) any later version.

The KForge wallpaper featured in the downloadable KForge VM uses the KDE logo, whose use is restricted as follows: "The KDE logo can be used freely as long as it is not used to refer to projects other than KDE itself. There is no formal procedure to use it. Copying of the KDE Logo is subject to the LGPL copyright license. Trading and branding with the KDE Logo is subject to our trademark licence." (Quoting from https://kde.org/stuff/clipart/) The KForge wallpaper is subject to the same licensing terms.
