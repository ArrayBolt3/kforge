# KForge

## The (hopefully) Ultimate KDE Build Environment

KForge is a virtual machine appliance running a customized version of KDE neon Developer Edition, designed to be ready for developing KDE Plasma and KDE applications from the word "Go". While KDE neon Developer Edition comes with extra components to make building KDE software easier, KForge comes with a full suite of KDE development tools preinstalled and ready to be used.

KForge comes in two variants - the virtual machine appliance itself, and a setup script that can be ran on a KDE neon Developer Edition VM to turn it into KForge. The VM appliance is designed for use with VirtualBox. It takes a while to download but is already fully prepared for use. The scripts are quicker to download but require that you install KDE neon Developer Edition yourself, and so are more labor-intensive.

Due to GitHub's file size limitations, the full VM appliance has been split into 1.8 GiB chunks. Since downloading and concatenating these chunks can be somewhat of an hassle, there's also will be a download script included with KForge that will automatically do the whole job for you and leave you with the finished disk image.

KForge is currently in alpha testing - don't expect everything to work right yet.

## Disclaimers

This is a developer tool. As such, it is designed for people who mostly know what they're doing. These instructions don't clearly spell out all the possible "gotchas" (like being dreadfully careful with the terrifying `rm -rf` command). Since the whole entire system is designed to build and run alpha-quality and pre-alpha-quality code, there are almost certainly many bugs all through this.

If you don't know what you're doing, or if you don't clearly understand **everything** you read in this guide, **DO NOT USE THIS TOOL OR RUN ANY COMMANDS IN THIS GUIDE.** Running some of these commands in the wrong context could have unintended (and possibly catastrophic) results. Using the tool as a general-purpose operating system is likely to turn out disappointing. If you know what you're doing, none of this will deter you in the slightest. But if reading this gives you second thoughts, listen to them. Turn back now!

For those who are still with me, proceed.

## Getting KForge

### Downloading the VM

1. Clone the KForge repository to your physical machine with `git clone https://github.com/ArrayBolt3/KForge.git`.
2. Open a terminal in the kforge folder created when you did the clone.
3. Run `./KForgeDL.sh`, and wait. It may take a while. When the command finishes, you will be left with a file named "KForge.ova" in the kforge folder.
4. Using VirtualBox, import the KForge.ova appliance.
5. Power on the VM. It will log in automatically and grant you passwordless sudo access.
6. Once the VM is up and running, log in open a terminal inside the VM and run `sudo apt update && sudo apt -y full-upgrade`.
7. Finally, run `CXX=/usr/bin/g++-10 kdesrc-build <kdecomponent>`, replacing `<kdecomponent>` with the name of the KDE component you want to start work on. This will update the source code for this KDE component and rebuild it, preparing it for use.

That's it! You're now ready to begin development. Should you need to log in for some reason (for instance, switching to a TYY), the password is a single lowercase "z".

### Using the prep scripts

1. Download KDE neon Developer Edition from here: https://files.kde.org/neon/images/developer/current/ Make sure to download the sha256sum file (or the .sig file if you want to be really cautious) and use it to verify the ISO file before creating a VM with it.
2. Using your virtualization software of choice, create a KDE neon VM. **It is highly recommended that you provide the VM with at least 8 GiB of RAM and 128 GiB of disk space.**
3. Once you have installed KDE neon, clone the KForge repository to your virtual machine with `git clone https://github.com/ArrayBolt3/KForge.git`.
4. Run `cd KForge && ./KForgeInstaller.sh`. You will be asked for the VMs password, possibly multiple times, depending on how long it takes for the first stage of VM preparation to finish. You will also have to press "y" at least once during the setup, so it's not fully unattended (yet). When the VM preparation has finished, the VM will automatically reboot.
5. When the VM finishes rebooting, log in, open System Settings, search for "File" and open "File Search". Then exclude the ~/kde directory from file indexing.

If all goes as planned, you're done!

## Using KForge

The KDE software build process is managed by kdesrc-build. Since KDE neon is still based on Ubuntu 20.04, the default compiler is GCC 9, which isn't new enough to build all components of KDE (most notably I found KWin failed to build with GCC 9). However, GCC 10 is also installed. To ensure that everything builds properly, you currently need to specifically tell CMake (the build system kdesrc-build wields behind the scenes) to use GCC 10. To do this, any time you run kdesrc-build, you should run it as `CXX=/usr/bin/g++-10 kdesrc-build <options>`. There may be a way to set GCC 10 as the default compiler for CMake, but currently this isn't implemented. (Probably a simple variable export in .bashrc will do the trick, though I haven't tested this and my Bash skills aren't sufficiently up to par for me to know if that will work.)

Documentation on how to use kdesrc-build is here: https://docs.kde.org/trunk5/en/kdesrc-build/kdesrc-build/index.html Some quick commands that will come in handy:

* To build a KDE component and stuff it depends on for the first time (or update the source and rebuild it): `CXX=/usr/bin/g++-10 kdesrc-build <kdecomponent>`
* To rebuild a project quickly for testing a change you just made: `CXX=/usr/bin/g++-10 kdesrc-build --no-src --no-include-dependencies <kdecomponent>`
* To discard any changes you've made to a component and rebuild it "clean": `rm -rf ~/kde/src/<kdecomponent> && CXX=/usr/bin/g++-10 kdesrc-build <kdecomponent>`
* To scrap EVERYTHING and start from scratch, building the full KDE Plasma stack (useful for if you get your stuff really scrambled, like if your computer crashes mid-build):

```
mv ~/kde/src/kdesrc-build ~/kdesrc-build-bak
rm -rf ~/kde
mkdir -p ~/kde/src
mv ~/kdesrc-build-bak ~/kde/src/kdesrc-build
kdesrc-build --initial-setup                    # When asked to update your .bashrc, answer "n", since it's already been updated once
CXX=/usr/bin/g++-10 kdesrc-build plasma-workspace plasma-framework plasma-integration bluedevil powerdevil plasma-nm plasma-pa plasma-thunderbolt plasma-vault plasma-firewall plasma-workspace-wallpapers kdeplasma-addons krunner milou kwin kscreen sddm-kcm plymouth-kcm breeze discover print-manager plasma-sdk kaccounts-integration kaccounts-providers kdeconnect-kde plasma-browser-integration xdg-desktop-portal-kde kde-gtk-config khotkeys kgamma5 breeze-gtk drkonqi phonon --include-dependencies
CXX=/usr/bin/g++-10 kdesrc-build plasma-desktop systemsettings ksysguard plasma-disks plasma-systemmonitor ksystemstats kinfocenter kmenuedit --include-dependencies
```

## Software KForge won't build

While KForge is able to build *almost* all KDE software, there are a few exceptions. The proper build dependencies for the following software are **not** installed in KForge and attempting to build them will result in errors. If you really need to build these, you can install the dependencies into KForge manually.

* Krita. Krita is massive, and as testing KForge requires building vast amounts of KDE software on a regular basis, the extra time that would be needed to build Krita routinely is currently believed to be too much. Additionally, there is already a dedicated Krita build environment known as Krita Devbox, which is available here: https://invent.kde.org/eoinoneill/krita-devbox
* Kdenlive. As handy and awesome as Kdenlive is, it requires the installation of build dependencies that are potentially problematic due to issues invovling patents (ffmpeg being one of the biggest problems here). It is also seriously big and might be too cumbersome to build on a regular basis.
* telepathy-accounts-signon. KDE Telepathy is, to the best of my knowledge, unmaintained. You'll probably never need to (or want to) build it. Additionally, not all of the necessary build dependencies for telepathy-accounts-signon are available in KDE neon, making this far more tricky to build than normal.

## License and Copyright Info

See the "COPYRIGHT" file for copyright and licensing information. The repository's main license is the GNU GPL v2 or later.
