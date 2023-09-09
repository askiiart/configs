#!/usr/bin/env bash
# Exit if there's an error
set -e

if [ $(whoami) != "root" ]; then
    SUDO="sudo"
else
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    sudo apt-get install zsh -y
elif command_exists "yum"; then
    sudo yum install zsh util-linux-user -y
elif command_exists "pacman"; then
    sudo pacman -S zsh --noconfirm --needed
elif command_exists "zypper"; then
    sudo zypper install zsh -y
elif command_exists "emerge"; then
    sudo emerge app-shells/zsh
    sudo emerge app-shells/zsh-completions
    sudo emerge app-shells/gentoo-zsh-completions
elif command_exists "apk"; then
    sudo apk add zsh -y
else
    echo >&2 "Unsupported: unknown package manager and distro"
    exit 1
fi

git submodule update --init --recursive
cp -r zsh-files/.oh-my-zsh ~/
cp -r zsh-files/.zkbd ~/
cp zsh-files/.zshrc ~/

chsh -s $(which zsh)
