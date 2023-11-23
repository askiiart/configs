#!/usr/bin/env bash
set -e

if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    sudo apt-get install fish -y
elif command_exists "yum"; then
    sudo yum install fish -y
elif command_exists "pacman"; then
    yay -S fish
elif command_exists "zypp"; then
    # Untested
    sudo zypper install fish -y
elif command_exists "emerge"; then
    sudo echo Not yet supported, exiting...
    exit
elif command_exists "apk"; then
    sudo apk add fish
else
    echo "Unsupported: unknown package manager and distro"
    exit
fi

chsh -s $(readlink -f $(which fish))
