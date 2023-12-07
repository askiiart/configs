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
    sudo yum install kitty neovim -y
    curl -LO $(curl -s https://api.github.com/repos/SchildiChat/schildichat-desktop/releases/latest | grep "browser_download_url.*schildichat-desktop-.*.x86_64.rpm" | cut -d : -f 2,3 | tr -d \")
    sudo dnf install ./schildichat-desktop-*.x86_64.rpm
    sudo rm ./schildichat-desktop-*.x86_64.rpm
elif command_exists "yay"; then
    yay -S kitty schildichat-desktop-bin digikam eog man-db neovim --noconfirm --needed
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
