#!/usr/bin/env bash
set -e

if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

echo "WARNING: Only Arch is fully supported"

if command_exists "apt-get"; then
    sudo apt-get install kitty -y
    echo "Please install SchildiChat, nvim/neovim"
elif command_exists "yum"; then
    sudo yum install kitty -y
    echo "Please install SchildiChat, nvim/neovim"
elif command_exists "yay"; then
    yay -S kitty --noconfirm --needed
    yay -S schildichat-desktop-bin --noconfirm --needed
elif command_exists "zypp"; then
    # Untested
    sudo zypper install kitty -y
    echo "Please install SchildiChat, nvim/neovim"
elif command_exists "emerge"; then
    echo Not yet supported, exiting...
    exit
elif command_exists "apk"; then
    echo Not yet supported, exiting...
else
    echo "Unsupported: unknown package manager and distro"
    exit
fi
