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
elif command_exists "dnf"; then
    sudo dnf install steam -y
    sudo dnf install appimagelauncher qt5-qtbase-gui -y
    mkdir $HOME/Applications
    cd $HOME/Applications
    curl -LO $(curl -s https://api.github.com/repos/DavidoTek/ProtonUp-Qt/releases/latest | grep "browser_download_url.*ProtonUp-Qt-.*-x86_64.AppImage" | head --lines 1 | cut -d : -f 2,3 | tr -d \") -C -
    cd -  # throws an error but it works?
    AppImageLauncherSettings &
    sleep 5
    kill $(pidof AppImageLauncherSettings)
    sudo dnf install gperftools-libs-2.9.1-6.fc39.i686
elif command_exists "yay"; then
    #printf '[multilib]\nInclude = /etc/pacman.d/mirrorlist\n'
    #read -p "Enable the multilib repo in /etc/pacman.conf - look above"
    #sudo $EDITOR /etc/pacman.conf
    yay -S steam
    yay -S protonup-qt-bin dosbox inotify-tools timidity scummvm xdotool xwinfo yad --noconfirm --needed
else
    echo "IDK"
fi
