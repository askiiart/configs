#!/usr/bin/env bash
set -e
if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    curl -LO $(curl -s https://api.github.com/repos/Vencord/Vesktop/releases/latest | grep "vesktop_.*_amd64.deb" | head --lines 1 | cut -d : -f 2,3 | tr -d \")
    sudo apt-get install ./vesktop_*.deb -y
elif command_exists "yum"; then
    curl -LO $(curl -s https://api.github.com/repos/Vencord/Vesktop/releases/latest | grep "browser_download_url.*vesktop-.*.x86_64.rpm" | head --lines 1 | cut -d : -f 2,3 | tr -d \")
    sudo dnf install ./vesktop-*.rpm -y
    rm ./vesktop-*.rpm
elif command_exists "pacman"; then
    yay -S vesktop-bin --noconfirm --needed
else
    echo "IDK, check the repo: https://github.com/Vencord/Vesktop"
fi
