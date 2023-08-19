#!/bin/bash

# Wait until enter is pressed
# read -p "Press Enter to continue" < /dev/tty

sudo dnf install git -y

# Install git credential manager
curl -L https://aka.ms/gcm/linux-install-source.sh | sh
git-credential-manager configure

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
echo This is the exported key, copy it and put it in Git*
echo Gitea URL: https://git.askiiart.net/user/settings/keys
echo GitHub URL: https://github.com/settings/gpg/new
read -p "Press enter when you're done" < /dev/tty

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
echo This is the SSH public key, copy it and put it in Gitea/GitHub/whatever
echo Gitea URL: https://git.askiiart.net/user/settings/keys
echo GitHub URL: https://github.com/settings/ssh/new

read -p "Done. Now verify your SSH and GPG keys in Git*" < /dev/tty