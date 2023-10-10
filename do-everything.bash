#!/usr/bin/env sh
cd ./dotfiles
chmod 700 restore.sh
./restore.sh
cd ..

chmod 700 ./distro-specific.bash
./distro-specific.bash

cd ./daily-use-pcs
chmod 700 ./setup-git.bash
./setup-git.bash
cd ..

cd install-stuff/
chmod 700 ./*.bash
./install-armcord.bash
./install-fish.bash
./install-librewolf.bash
./install-qemu-libvirt.bash
./install-steam.bash
./install-vs-code.bash
./install-yt-music.bash
cd ..
