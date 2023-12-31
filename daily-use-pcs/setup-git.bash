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
    sudo apt-get install pass git -y
elif command_exists "yum"; then
    sudo yum install pass git -y
elif command_exists "pacman"; then
    sudo pacman -S git --noconfirm --needed
    sudo pacman -S pass --noconfirm --needed
elif command_exists "zypp"; then
    sudo zypper install pass git -y
elif command_exists "emerge"; then
    sudo echo Not yet supported, exiting...
elif command_exists "apk"; then
    sudo apk add pass
    sudo apk add git
else
    echo "Unsupported: unknown package manager and distro"
fi

# Check if GCM is installed
if [ -d "${HOME}/git-credential-manager" ]; then
    echo "Git Credential Manager already installed, skipping..."
else
    if command_exists "apt-get"; then
        curl $(curl -s https://api.github.com/repos/git-ecosystem/git-credential-manager/releases/latest | grep "browser_download_url.*gcm-linux_amd64.*.deb" | cut -d : -f 2,3 | tr -d \") -LO
        chmod 777 ./gcm-linux_amd64.*.deb
        sudo apt-get install ./gcm-linux_amd64.*.deb -y
        rm -f ./gcm-linux_amd64.*.deb
    else
        # Install git credential manager
        curl -L https://aka.ms/gcm/linux-install-source.sh | sh
        rm dotnet-install.sh
    fi
fi

############################################
# Do GPG key stuff for commit verification #
############################################
git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"
git-credential-manager configure
git config --global commit.gpgsign true
git config --global credential.credentialStore gpg

echo "GPG key ID: ${KEY_ID}"
echo "Go to https://github.com/drduh/YubiKey-Guide to set up git with GPG"
read -p "Mirrored at https://git.askiiart.net/mirrors/YubiKey-Guide"

git config --global user.signingkey ${KEY_ID}
pass init ${KEY_ID}

#############
# SSH stuff #
#############

# Get SSH key
if [ -d "${HOME}/.ssh" ]; then
    echo "SSH keys already exist, skipping..."
else
    # Generate SSH keys
    echo
    # -f: file, -N: passphrase, -t: type
    ssh-keygen -f ~/.ssh/id_rsa -N "" -t rsa
    echo
fi

# From https://superuser.com/a/954639
# Archived at https://web.archive.org/web/20230606153856/https://superuser.com/a/954639
echo Fixing .gnupg/ permissions
# Set ownership to your own user and primary group
chown -R "$USER:$(id -gn)" ~/.gnupg
# Set permissions to read, write, execute for only yourself, no others
chmod 700 ~/.gnupg
# Set permissions to read, write for only yourself, no others
chmod 600 ~/.gnupg/*
# Fixes dirmngr stuff
sudo chmod 700 $(ls -d $HOME/.gnupg/*/)

read -p "Done. Now verify your SSH and GPG keys in Git*" </dev/tty

# Export GPG key
gpg --armor --export $KEY_ID
echo This is the exported key, copy it and put it in GitHub/Gitea/whatever
echo Gitea URL: ${GITEA_URL}/user/settings/keys
echo GitHub URL: https://github.com/settings/gpg/new
read -p "Press enter when you're done" </dev/tty

cat ~/.ssh/id_rsa.pub
echo This is the SSH public key, copy it and put it in GitHub/Gitea/whatever
echo Gitea URL: ${GITEA_URL}/user/settings/keys
echo GitHub URL: https://github.com/settings/ssh/new
read -p "Press enter when you're done" </dev/tty
