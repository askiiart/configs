#!/bin/bash
command_exists() { type "$1" &> /dev/null; }

if command_exists "apt-get"; then
    PM="apt-get"
elif command_exists "yum"; then
    PM="yum"
fi

echo $PM