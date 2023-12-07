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
elif command_exists "dnf"; then
    sudo dnf config-manager --add-repo https://askiiart.net/repos/fedora/x86_64/askiiart.repo
    sudo dnf remove libreoffice* firefox atril -y
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
elif command_exists "pacman"; then
    WD=$(pwd)
    sudo pacman -S --noconfirm --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd $WD
    rm -rf yay
    yay -S noto-fonts-emoji --noconfirm --needed
    sudo mkdir /usr/share/fonts/meslolgs
    yay -S ttf-meslo-nerd-font-powerlevel10k --noconfirm --needed
elif command_exists "zypp"; then
    echo "not yet implemented"
elif command_exists "emerge"; then
    echo "not yet implemented"
elif command_exists "apk"; then
    echo "not yet implemented"
else
    echo "Unsupported: unknown package manager and distro"
fi
