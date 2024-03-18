#!/usr/bin/env sh

chmod 700 ./distro-specific.bash
./distro-specific.bash

cd ./daily-use-pcs
chmod 700 ./setup-git.bash
./setup-git.bash
cd ..

cd install-stuff/
chmod 700 ./*.bash
./install-vesktop.bash
./install-claws-mail.bash
./install-fish.bash
./install-librewolf.bash
./install-misc.sh
./install-qemu-libvirt.bash
./install-steam.bash
./install-vs-code.bash
./install-yt-music.bash
cd ..

cd ./dotfiles
chmod 700 restore.sh
./restore.sh
cd ..
