#!/usr/bin/env bash
# Exit if there's an error
set -e
# Modify constants as needed
GITEA_URL="https://git.askiiart.net"
NAME="askiiart"
EMAIL="dev@askiiart.net"

# Note: This waits until enter is pressed
# read -p "Press Enter to continue" < /dev/tty

if [ $(whoami) != "root" ]; then
    SUDO="sudo"
else
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    $SUDO apt-get install pass git -y
elif command_exists "yum"; then
    $SUDO yum install pass git -y
elif command_exists "pacman"; then
    $SUDO pacman -S git --noconfirm
    $SUDO pacman -S pass --noconfirm
elif command_exists "zypp"; then
    $SUDO zypper install pass git -y
elif command_exists "emerge"; then
    $SUDO echo Not yet supported, exiting...
elif command_exists "apk"; then
    $SUDO apk add pass
    $SUDO apk add git
else
    echo "Unsupported: unknown package manager"
fi

# Check if GCM is installed
if [ -d "${HOME}/git-credential-manager" ]; then
    echo "Git Credential Manager already installed, skipping..."
else
    # Install git credential manager
    curl -L https://aka.ms/gcm/linux-install-source.sh | sh
    git-credential-manager configure
    rm dotnet-install.sh
fi

############################################
# Do GPG key stuff for commit verification #
############################################
if [ -d "${HOME}/.gnupg/" ]; then
    echo "GPG key(s) already exist, skipping..."
else
# Create GPG key
    echo "> $ gpg --full-generate-key"
    echo
    echo Use the defaults, then real name "askiiart", email address \"dev@askiiart.net\", and comment \"git key\"\n
    echo
    gpg --full-generate-key
    read -p "Copy the long ID above, then paste it here: " KEY_ID
    echo $KEY_ID

    # Export GPG key
    gpg --armor --export $KEY_ID
    echo This is the exported key, copy it and put it in GitHub/Gitea/whatever
    echo Gitea URL: ${GITEA_URL}/user/settings/keys
    echo GitHub URL: https://github.com/settings/gpg/new
    read -p "Press enter when you're done" </dev/tty
    pass init ${KEY_ID}
fi

echo Doing git config stuff...
git config --global credential.credentialStore gpg
git config --global user.name "${NAME}"
git config --global user.email "${EMAIL}"

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
    cat ~/.ssh/id_rsa.pub
    echo This is the SSH public key, copy it and put it in GitHub/Gitea/whatever
    echo Gitea URL: ${GITEA_URL}/user/settings/keys
    echo GitHub URL: https://github.com/settings/ssh/new
fi
echo Fixing permissions
sudo chown -R $(whoami) /home/$(whoami)/.gnupg
sudo chgrp -R $(whoami) /home/$(whoami)/.gnupg
sudo chmod -R 600 /home/$(whoami)/.gnupg

read -p "Done. Now verify your SSH and GPG keys in Git*" </dev/tty
