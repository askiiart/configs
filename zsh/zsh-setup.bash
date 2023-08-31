#!/usr/bin/env bash
# Exit if there's an error
set -e

if [ $(whoami) != "root" ]; then
    $SUDO = "sudo"
else
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    $SUDO apt-get install zsh -y
elif command_exists "yum"; then
    $SUDO apt-get install zsh -y
elif command_exists "pacman"; then
    $SUDO pacman -S zsh --noconfirm --needed
elif command_exists "zypper"; then
    $SUDO zypper install zsh -y
elif command_exists "emerge"; then
    $SUDO emerge --ask app-shells/zsh
    $SUDO emerge --ask app-shells/zsh-completions
    $SUDO emerge --ask app-shells/gentoo-zsh-completions
elif command_exists "apk"; then
    $SUDO apk add zsh -y
else
    echo >&2 "Unsupported: unknown package manager"
    exit 1
fi

cp -r zsh-files/.* ~/
