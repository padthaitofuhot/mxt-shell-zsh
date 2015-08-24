#!/usr/bin/env bash
shopt -s nocasematch

SCRIPTROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ETCFILES="$SCRIPTROOT/../conf/etc"
DOTFILES="$SCRIPTROOT/../conf/dotfiles"
BACKUPS="$HOME/.backup/mxt-shell-zsh"

# Make backups
if [ -x /bin/cygtermd.exe ]; then
    if ! [ -d "$BACKUPS/bin" ]; then
        printf "Creating backup directory in %s\n" "$BACKUPS/bin"
        mkdir -p "$BACKUPS/bin"
    fi
    printf "Backing up /bin/cygtermd.exe\n"
    cp /bin/cygtermd.exe $BACKUPS/bin/cygtermd.exe
fi

CURDIR="$PWD"

cd $SCRIPTROOT/src/cygtemd

printf "Building cygtermd.exe\n"
make

printf "Replacing /bin/cygtermd.exe\n"
rm -f /bin/cygtermd.exe
install -c $SCRIPTROOT/src/cygtemd/cygtermd.exe /bin/cygtermd.exe

cd "$CURDIR"

shopt -u nocasematch
