#!/usr/bin/env bash
EDITOR=nano

if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    curl -LO https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb
    sudo dpkg -i steam.deb
elif command_exists "yum"; then
    sudo dnf install steam -y
elif command_exists "yay"; then
    printf '[multilib]\nInclude = /etc/pacman.d/mirrorlist\n'
    read -p "Enable the multilib repo in /etc/pacman.conf - look above"
    sudo $EDITOR /etc/pacman.conf
    yay -S steam --noconfirm --needed
    yay -S appimagelauncher --noconfirm --needed
    mkdir $HOME/Applications
    curl $(curl -s https://api.github.com/repos/DavidoTek/ProtonUp-Qt/releases/latest | grep "browser_download_url.*ProtonUp-Qt-.*-x86_64.AppImage" | cut -d : -f 2,3 | tr -d \") -LO
    mv ProtonUp*.AppImage $HOME/Applications/
    yay -S dosbox inotify-tools timidity scummvm xdotool xwinfo yad --noconfirm --needed
else
    echo "IDK"
fi
