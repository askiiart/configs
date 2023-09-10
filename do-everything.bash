#!/usr/bin/env sh
chmod 700 ./distro-specific.bash
./distro-specific.bash

cd ./daily-use-pcs
chmod 700 ./setup-git.bash
./setup-git.bash
cd ..

cd install-stuff/
chmod 700 ./*.bash
./*.bash
cd ..