#!/usr/bin/env bash
set -e
if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    sudo apt update
    sudo apt install curl -y
elif command_exists "yum"; then
    sudo dnf config-manager --add-repo https://askiiart.net/repos/fedora/x86_64/askiiart.repo
elif command_exists "pacman"; then
    WD=$(pwd)
    pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd $WD
elif command_exists "zypp"; then
    # Untested
    echo "not yet implemented"
elif command_exists "emerge"; then
    echo "not yet implemented"
elif command_exists "apk"; then
    echo "not yet implemented"
else
    echo "Unsupported: unknown package manager and distro"
fi
