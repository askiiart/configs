#!/usr/bin/env bash
set -e
if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    curl $(curl -s https://api.github.com/repos/Vencord/Vesktop/releases/latest | grep "VencordDesktop_.*_amd64.deb" | head --lines 1 | cut -d : -f 2,3 | tr -d \") -LO
    sudo apt-get install ./VencordDesktop_*.deb -y
elif command_exists "yum"; then
    curl $(curl -s https://api.github.com/repos/Vencord/Vesktop/releases/latest | grep "VencordDesktop-.*.x86_64.rpm" | head --lines 1 | cut -d : -f 2,3 | tr -d \") -LO
    sudo apt install ./VencordDesktop*.rpm -y
elif command_exists "pacman"; then
    yay -S vencord-desktop-bin --noconfirm --needed
else
    echo "IDK, check the repo: https://github.com/Vencord/Vesktop"
fi
