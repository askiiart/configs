#!/usr/bin/env bash
set -e
if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    sudo curl -L https://askiiart.net/repos/debian/dists/bookworm/stable/binary-amd64/askiiart.list -o /etc/apt/sources.list.d/askiiart.list
    sudo apt update --allow-insecure-repositories
    sudo apt install youtube-music -y --allow-unauthenticated
elif command_exists "yum"; then
    sudo dnf config-manager --add-repo https://askiiart.net/repos/fedora/x86_64/askiiart.repo
    sudo dnf install youtube-music -y
elif command_exists "yay"; then
    yay -S youtube-music-bin --noconfirm --needed
else
    echo "IDK, check the repo: https://github.com/th-ch/youtube-music"
fi
