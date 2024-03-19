#!/usr/bin/env bash
set -e

if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    sudo apt-get install kitty -y
    echo "Please install SchildiChat, nvim/neovim"
elif command_exists "dnf"; then
    sudo dnf install kitty neovim gcc gnome-hexgl drawing make vlc freeglut ncdu gcolor3 rust cargo clippy p7zip mosh krita podman podman-docker podman-compose gajim schildichat-desktop -y

    # Install Prism Launcher
    sudo dnf copr enable g3tchoo/prismlauncher
    sudo dnf install prismlauncher-qt5
elif command_exists "yay"; then
    yay -S kitty schildichat-desktop-bin digikam eog man-db neovim prismlauncher-qt5-bin --noconfirm --needed
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

sudo mkdir /usr/share/fonts/meslolgs
sudo curl 'https://raw.githubusercontent.com/IlanCosman/tide/assets/fonts/mesloLGS_NF_regular.ttf' -o '/usr/share/fonts/meslolgs/mesloLGS_NF_regular.ttf'
sudo curl 'https://raw.githubusercontent.com/IlanCosman/tide/assets/fonts/mesloLGS_NF_bold.ttf?raw=true' -o '/usr/share/fonts/meslolgs/mesloLGS_NF_bold.ttf'
sudo curl 'https://raw.githubusercontent.com/IlanCosman/tide/assets/fonts/mesloLGS_NF_italic.ttf?raw=true' -o '/usr/share/fonts/meslolgs/mesloLGS_NF_italic.ttf'
sudo curl 'https://raw.githubusercontent.com/IlanCosman/tide/assets/fonts/mesloLGS_NF_bold_italic.ttf?raw=true' -o '/usr/share/fonts/meslolgs/mesloLGS_NF_bold_italic.ttf'
