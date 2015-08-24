#!/usr/bin/env bash
shopt -s nocasematch

printf "Checking and installing requirements\n"

for pkg in apt-cyg gcc; do
    if [ -z "$(which gcc)" ]; then
        while [[ "${yn,,}" =~ [yn] ]]; do
            printf "No %s in your path.\nShall I install %s now [y/n]? " "$pkg" "$pkg"
            read yn
        done
        if [ "$yn" == "y" ]; then
            if [ "$pkg" == "apt-cyg" ]; then
                : # TODO: Install apt-cyg
            else
                apt-cyg install "$pkg"
            fi
        else
            : # TODO: Complain or something
        fi
    else
        printf "Found package: %s\n" "$pkg"
    fi
done

shopt -u nocasematch
