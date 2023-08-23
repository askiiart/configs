#!/usr/bin/env bash
# Exit if there's an error
set -e
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

sudo ${PACKAGE_MANAGER} install zsh -y

cp -r zsh-files/* ~/