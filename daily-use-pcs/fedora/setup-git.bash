#!/usr/bin/env bash
# Exit if there's an error
set -e
# Modify constants as needed
GITEA_URL="https://git.askiiart.net"
REAL_NAME="askiiart"
EMAIL="dev@askiiart.net"

# Note: This waits until enter is pressed
# read -p "Press Enter to continue" < /dev/tty

declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt-get
osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        PACKAGE_MANAGER=${osInfo[$f]}
    fi
done

sudo ${PACKAGE_MANAGER} install pass git -y

# Check if GCM is installed
if [ -f "${HOME}/.git-credentials" ]; then
    echo "Git Credential Manager already installed, skipping..."
else
    # Install git credential manager
    curl -L https://aka.ms/gcm/linux-install-source.sh | sh
    git-credential-manager configure
fi

############################################
# Do GPG key stuff for commit verification #
############################################

# Create GPG key
echo "> $ gpg --full-generate-key"
echo Use the defaults, then real name "askiiart", email address \"dev@askiiart.net\", and comment \"git key\"\n
gpg --full-generate-key
read -p "Copy the long ID above, then paste it here: " KEY_ID
echo $KEY_ID

# Export GPG key
gpg --armor --export $KEY_ID
echo This is the exported key, copy it and put it in GitHub/Gitea/whatever
echo Gitea URL: ${GITEA_URL}/user/settings/keys
echo GitHub URL: https://github.com/settings/gpg/new
read -p "Press enter when you're done" < /dev/tty

echo Doing GCM config stuff...
git config --global credential.credentialStore gpg
pass init ${KEY_ID}

#############
# SSH stuff #
#############

# Generate SSH keys
echo
# -f: file, -N: passphrase, -t: type
ssh-keygen -f ~/.ssh/id_rsa -N "" -t rsa

# Get SSH key
echo
cat ~/.ssh/id_rsa.pub
echo This is the SSH public key, copy it and put it in GitHub/Gitea/whatever
echo Gitea URL: ${GITEA_URL}/user/settings/keys
echo GitHub URL: https://github.com/settings/ssh/new

echo Fixing permissions, removing temp files...
sudo chown -R $(whoami) /home/$(whoami)/.gnupg
sudo chgrp -R $(whoami) /home/$(whoami)/.gnupg
sudo chmod -R 700 /home/$(whoami)/.gnupg
rm dotnet-install.sh

read -p "Done. Now verify your SSH and GPG keys in Git*" < /dev/tty