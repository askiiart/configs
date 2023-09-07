#!/usr/bin/env bash
# Exit if there's an error
set -e
# Modify constants as needed
GITEA_URL="https://git.askiiart.net"
NAME="askiiart"
EMAIL="dev@askiiart.net"

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
    sudo pacman -S git --noconfirm
    sudo pacman -S pass --noconfirm
elif command_exists "zypp"; then
    sudo zypper install pass git -y
elif command_exists "emerge"; then
    sudo echo Not yet supported, exiting...
elif command_exists "apk"; then
    sudo apk add pass
    sudo apk add git
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
else
    gpg --list-keys
    read -p "Enter the long ID of the key to be used for git:" KEY_ID
fi

echo Doing git config stuff...
git config --global credential.credentialStore gpg
git config --global user.name "${NAME}"
git config --global user.email "${EMAIL}"
git config --global user.signingkey ${KEY_ID}
git config --global commit.gpgsign true
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
    cat ~/.ssh/id_rsa.pub
    echo This is the SSH public key, copy it and put it in GitHub/Gitea/whatever
    echo Gitea URL: ${GITEA_URL}/user/settings/keys
    echo GitHub URL: https://github.com/settings/ssh/new
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

read -p "Done. Now verify your SSH and GPG keys in Git*" </dev/tty
