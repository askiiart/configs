#!/usr/bin/env bash
set -e
if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    sudo apt update && sudo apt install -y wget gnupg lsb-release apt-transport-https ca-certificates
    distro=$(if echo " una bookworm vanessa focal jammy bullseye vera uma " | grep -q " $(lsb_release -sc) "; then echo $(lsb_release -sc); else echo focal; fi)
    wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
    echo "Types: deb\nURIs: https://deb.librewolf.net\nSuites: $distro\nComponents: main\nArchitectures: amd64\nSigned-By: /usr/share/keyrings/librewolf.gpg" | sudo tee /etc/apt/sources.list.d/librewolf.sources
    sudo apt update
    sudo apt install librewolf -y
elif command_exists "dnf"; then
    sudo dnf config-manager --add-repo https://rpm.librewolf.net/librewolf-repo.repo
    sudo dnf install librewolf
    sudo dnf remove firefox
elif command_exists "yay"; then
    yay -S librewolf-bin
    yay -R firefox
elif command_exists "emerge"; then
    # Untested
    sudo eselect repository add librewolf git https://codeberg.org/librewolf/gentoo.git
    emaint -r librewolf sync
else
    echo "Figure it out yourself, or get the AppImage from here: https://gitlab.com/librewolf-community/browser/appimage/-/releases"
fi
