# KForge

## The (hopefully) Ultimate KDE Build Environment

KForge is a virtual machine appliance running a customized version of KDE neon Developer Edition, designed to be ready for developing KDE Plasma and KDE applications from the word "Go". While KDE neon Developer Edition comes with extra components to make building KDE software easier, KForge comes with a full suite of KDE development tools preinstalled and ready to be used.

KForge comes in two variants - the virtual machine appliance itself, and a setup script that can be ran on a KDE neon Developer Edition VM to turn it into KForge. The VM appliance is designed for use with VirtualBox. It takes a while to download but is already fully prepared for use. The scripts are quicker to download but require that you install KDE neon Developer Edition yourself, and so are more labor-intensive.

Due to GitHub's file size limitations, the full VM appliance has been split into 1.8 GiB chunks. Since downloading and concatenating these chunks can be somewhat of an hassle, there's also will be a download script included with KForge that will automatically do the whole job for you and leave you with the finished disk image.

KForge is currently in beta testing. Everything should work right, but it's not been thoroughly tested. Bug reports, feedback, and pull requests are all welcome!

## Disclaimers

***WARNING: READ THIS SECTION BEFORE PROCEEDING LEST YOU DESTROY THINGS.***

This is a developer tool. As such, it is designed for people who mostly know what they're doing. These instructions don't clearly spell out all the possible "gotchas" (like being dreadfully careful with the terrifying `rm -rf` command). Since the whole entire system is designed to build and run alpha-quality and pre-alpha-quality code, there are almost certainly many bugs all through this.

If you don't know what you're doing, or if you don't clearly understand **everything** you read in this guide, **DO NOT USE THIS TOOL OR RUN ANY COMMANDS IN THIS GUIDE.** Running some of these commands in the wrong context could have unintended (and possibly **catastrophic**) results. Using the tool as a general-purpose operating system is likely to turn out disappointing. If reading this gives you second thoughts, listen to them. Turn back now!

***YOU HAVE BEEN WARNED. PROCEED AT YOUR OWN RISK.***

## News

Info that may help you to be able to use KForge effectively.

* KDE Neon Developer Edition has been rebased onto Ubuntu 22.04, which uses a newer version of GCC. It is no longer necessary to set the GCC version when running compilation commands.
* There's finally an updated KForge appliance! Between a bunch of work and a problem with my Internet, I've not updated this in a while, but it's finally happened. Thanks for your patience!
* There is a bug in KForgePlasmaSetup.sh - libkscreen must be built before kscreen can be built, however the code doesn't necessarily make this happen. Please use `./buildMod libkscreen` before attempting to use `./buildAll` to avoid this problem.
* The screen locker is **not** disabled by default. Occasionally, the screen of the VM will lock. Sometimes during or after a kdesrc-build run, you will find that the screen can't be unlocked thereafter. To get around this, switch to a TTY using VirtualBox's virtual keyboard (or an similar feature of your virtualization software if not using VirtualBox), log in, and use loginctl to unlock the screen. Screen locking is planned to be disabled by default in a later release of KForge.

## Getting KForge

### Downloading the VM

The KForge appliance is designed for VirtualBox 6.1.40. If using the KForge Appliance with a newer version of VirtualBox, you may need to install a newer version of Guest Additions in order for everything to work right.

1. Clone the KForge repository to your physical machine with `git clone https://github.com/ArrayBolt3/KForge.git`.
2. Open a terminal in the kforge folder created when you did the clone.
3. Run `./KForgeDL.sh`, and wait. It may take a while. When the command finishes, you will be left with a file named "KForge.ova" in the kforge folder.
4. Using VirtualBox, import the KForge.ova appliance.
5. Power on the VM. It will log in automatically and grant you passwordless sudo access.
6. Once the VM is up and running, log in open a terminal inside the VM and run `sudo apt update && sudo apt -y full-upgrade`.
7. Finally, run `kdesrc-build <kdecomponent>`, replacing `<kdecomponent>` with the name of the KDE component you want to start work on. This will update the source code for this KDE component and rebuild it, preparing it for use.

That's it! You're now ready to begin development. Should you need to log in for some reason (for instance, switching to a TTY), the password is a single lowercase "z".

### Using the KForge Installer

1. Download KDE neon Developer Edition from here: https://files.kde.org/neon/images/developer/current/ Make sure to download the sha256sum file (or the .sig file if you want to be really cautious) and use it to verify the ISO file before creating a VM with it.
2. Using your virtualization software of choice, create a KDE neon VM. **It is highly recommended that you provide the VM with at least 8 GiB of RAM and 128 GiB of disk space.**
3. Once you have installed KDE neon, clone the KForge repository to your virtual machine with `git clone https://github.com/ArrayBolt3/KForge.git`.
4. Run `cd KForge && ./KForgeInstaller.sh`. You will be asked for the VMs password, possibly multiple times, depending on how long it takes for the first stage of VM preparation to finish. You will also have to press "y" at least once during the setup, so it's not fully unattended (yet). When the VM preparation has finished, the VM will automatically reboot.

If all goes as planned, you're done!

## Using KForge

### For main development work

Doocumentation on how to use kdesrc-build is here: https://docs.kde.org/trunk5/en/kdesrc-build/kdesrc-build/index.html Some quick commands that will come in handy:

* To build a KDE component and stuff it depends on for the first time (or update the source and rebuild it): `kdesrc-build <kdecomponent>`
* To rebuild a project quickly for testing a change you just made: `kdesrc-build --no-src --no-include-dependencies <kdecomponent>`
* To discard any changes you've made to a component and rebuild it "clean": `rm -rf ~/kde/src/<kdecomponent> && kdesrc-build <kdecomponent>`
* To scrap EVERYTHING and start from scratch, building the full KDE Plasma stack (useful for if you get your stuff really scrambled, like if your computer crashes mid-build):

```
mv ~/kde/src/kdesrc-build ~/kdesrc-build-bak
rm -rf ~/kde
mkdir -p ~/kde/src
mv ~/kdesrc-build-bak ~/kde/src/kdesrc-build
kdesrc-build --initial-setup                    # When asked to update your .bashrc, answer "n", since it's already been updated once
kdesrc-build plasma-workspace plasma-framework plasma-integration bluedevil powerdevil plasma-nm plasma-pa plasma-thunderbolt plasma-vault plasma-firewall plasma-workspace-wallpapers kdeplasma-addons krunner milou kwin kscreen sddm-kcm plymouth-kcm breeze discover print-manager plasma-sdk kaccounts-integration kaccounts-providers kdeconnect-kde plasma-browser-integration xdg-desktop-portal-kde kde-gtk-config khotkeys kgamma5 breeze-gtk drkonqi phonon --include-dependencies
kdesrc-build plasma-desktop systemsettings ksysguard plasma-disks plasma-systemmonitor ksystemstats kinfocenter kmenuedit --include-dependencies
```

### For backport work (or anything else where kdesrc-build doesn't work right)

While kdesrc-build is awesome for lots of usecases, occasionally it's easier to work with the individual Git repos directly. However, in the case of KDE Plasma, there's a *lot* of repos to work with, which can be quite tedious to manage manually. To help deal with this, KForge comes with its own helper tools specifically for working on KDE Plasma in situations where kdesrc-build doesn't work easily (like when backporting bugfixes to earlier versions of Plasma).

To prepare a KDE Plasma build environment, clone the KForge repo, `cd` to it, and then run `./KForgePlasmaSetup.sh <major version>.<minor version>`, replacing `<major version>` and `<minor version>` as appropriate. This will automatically install the helper tools, and will clone and checkout the Git repos. For instance, to prepare a build environment for Plasma 5.24, run `./KPlasmaBackportEnvInstaller.sh 5.24`.

The Plasma source code will be placed under ~/kplasma. The helper scripts "buildMod.sh" and "buildAll.sh" will also be placed in this directory. To build the entire KDE Plasma stack, run `./buildAll` while in the ~/kplasma directory. To build just one module, run `./buildMod <module>`, replacing <module> with the name of the module you want to build (i.e., kwin, plasma-desktop, etc.).

To switch Plasma versions, you can just run the KForgePlasmaSetup.sh script again. This will detect if you already have the source code downloaded, and if so, it will simply checkout a different branch in all of the repos. Note that if you have made changes to the code, they will be preserved, which on the one hand is possibly good, and on the other hand may leave old stuff in your source code. If you need to wipe everything and start from scratch, simply delete the entire ~/kplasma directory and run the KForgePlasmaSetup.sh script again.

## Software KForge won't build

While KForge is able to build *almost* all KDE software, there are a few exceptions. The proper build dependencies for the following software are **not** installed in KForge and attempting to build them will result in errors. If you really need to build these, you can install the dependencies into KForge manually.

* Krita. Krita is massive, and as testing KForge requires building vast amounts of KDE software on a regular basis, the extra time that would be needed to build Krita routinely is currently believed to be too much. Additionally, there is already a dedicated Krita build environment known as Krita Devbox, which is available here: https://invent.kde.org/eoinoneill/krita-devbox
* Kdenlive. As handy and awesome as Kdenlive is, it requires the installation of build dependencies that are potentially problematic due to issues invovling patents (ffmpeg being one of the biggest problems here). It is also seriously big and might be too cumbersome to build on a regular basis.
* telepathy-accounts-signon. KDE Telepathy is, to the best of my knowledge, unmaintained. You'll probably never need to (or want to) build it. Additionally, not all of the necessary build dependencies for telepathy-accounts-signon are available in KDE neon, making this far more tricky to build than normal.

## License and Copyright Info

See the "COPYRIGHT" file for copyright and licensing information. The repository's main license is the GNU GPL v2 or later.
