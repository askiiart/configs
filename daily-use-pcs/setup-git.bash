#!/usr/bin/env bash
# Exit if there's an error
set -e
# Modify constants as needed
GITEA_URL="https://git.askiiart.net"
GIT_NAME="askiiart"
GIT_EMAIL="dev@askiiart.net"
KEY_ID="02EFA1CE3C3E4AAD7A863AB8ED24985CA884CD61"

# Note: This waits until enter is pressed
# read -p "Press Enter to continue" < /dev/tty

if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    sudo apt-get install git -y
elif command_exists "yum"; then
    sudo yum install git -y
elif command_exists "pacman"; then
    sudo pacman -S git --noconfirm --needed
elif command_exists "zypp"; then
    sudo zypper install git -y
elif command_exists "emerge"; then
    sudo echo Not yet supported, exiting...
elif command_exists "apk"; then
    sudo apk add git
else
    echo "Unsupported: unknown package manager and distro"
fi

############################################
# Do GPG key stuff for commit verification #
############################################
git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"
git config --global commit.gpgsign true
git config --global user.signingkey ${KEY_ID}

# From https://superuser.com/a/954639
# Archived at https://web.archive.org/web/20230606153856/https://superuser.com/a/954639
echo Fixing .gnupg/ permissions
# Set ownership to your own user and primary group
chown -R "$USER:$(id -gn)" ~/.gnupg
# Set permissions to read, write, execute for only yourself, no others
chmod 700 ~/.gnupg
# Set permissions to read, write for only yourself, no others
chmod 600 ~/.gnupg/*
# Fixes dirmngr stuff (for Arch)
sudo chmod 700 $(ls -d $HOME/.gnupg/*/)
