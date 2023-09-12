#!/usr/bin/env bash
set -e
if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    sudo curl -L https://askiiart.net/repos/debian/bookworm/amd64/askiiart.list -C - -o /etc/apt/sources.list.d/askiiart.list
    sudo apt update --allow-insecure-repositories
    sudo apt install armcord -y
elif command_exists "yum"; then
    sudo dnf config-manager --add-repo https://askiiart.net/repos/fedora/x86_64/askiiart.repo
elif command_exists "pacman"; then
    yay -S armcord-bin
else
    echo "IDK, check ArmCord's GitHub repo: https://github.com/ArmCord/ArmCord"
fi
