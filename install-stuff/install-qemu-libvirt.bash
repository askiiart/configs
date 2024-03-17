#!/usr/bin/env bash
set -e
if [ $(whoami) == "root" ]; then
    echo "Run as a normal user, not root"
    exit 1
fi

command_exists() { type "$1" &>/dev/null; }

if command_exists "apt-get"; then
    sudo apt-get install qemu-system libvirt-daemon-system virt-manager -y
elif command_exists "yum"; then
    sudo yum install @Virtualization virt-manager -y
    sudo usermod -aG libvirt $(whoami)
elif command_exists "pacman"; then
    sudo pacman -S qemu-full --noconfirm --needed
    sudo pacman -S virt-manager --noconfirm --needed
elif command_exists "zypp"; then
    # Untested
    sudo zypper install qemu -y
elif command_exists "emerge"; then
    sudo echo Not yet supported, exiting...
elif command_exists "apk"; then
    sudo apk add qemu-img qemu-system-x86_64 libvirt-daemon py-libvirt py-libxml2
    sudo apk add git
    sudo rc-update add libvirtd
    sudo rc-service libvirtd start
else
    echo "Unsupported: unknown package manager and distro"
fi
