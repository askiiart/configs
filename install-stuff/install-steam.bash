#!/usr/bin/env bash
EDITOR=nano

if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    curl -LO https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb
    sudo dpkg -i steam.deb
elif command_exists "dnf"; then
    sudo dnf install steam -y
elif command_exists "yay"; then
    #printf '[multilib]\nInclude = /etc/pacman.d/mirrorlist\n'
    #read -p "Enable the multilib repo in /etc/pacman.conf - look above"
    #sudo $EDITOR /etc/pacman.conf
    yay -S steam
    yay -S protonup-qt-bin dosbox inotify-tools timidity scummvm xdotool xwinfo yad --noconfirm --needed
else
    echo "IDK"
fi
