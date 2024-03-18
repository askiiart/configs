#!/usr/bin/env bash
EDITOR=nano

if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "yay"; then
    yay -S claws-mail python-gpgme nuspell aspell aspell-en
    yay -S spamassassin
    sudo systemctl enable --now spamassassin.service
    cd ~
    git clone https://git.askiiart.net/askiiart/gpg-email-helper
    cd -
elif command_exists "dnf"; then
    sudo dnf install spamassassin claws-mail claws-mail-plugins-pgp claws-mail-plugins-spamassassin claws-mail-plugins-rssyl
    sudo systemctl enable --now spamassassin.service
    cd ~
    git clone https://git.askiiart.net/askiiart/gpg-email-helper
    cd -
else
    echo "IDK"
fi
