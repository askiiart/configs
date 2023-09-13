#!/usr/bin/env bash
set -e
if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    curl -LO https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb
    sudo dpkg -i steam.deb
elif command_exists "yum"; then
    sudo dnf install steam -y
elif command_exists "pacman"; then
    echo "[multilib]\nInclude = /etc/pacman.d/mirrorlist"
    read -p "Enable the multilib repo in /etc/pacman.conf - look above`
    $EDITOR /etc/pacman.conf
else
    echo "IDK"
fi
