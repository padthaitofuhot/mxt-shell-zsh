#!/usr/bin/env bash
shopt -s nocasematch

SCRIPTROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ETCFILES="$SCRIPTROOT/../conf/etc"
DOTFILES="$SCRIPTROOT/../conf/dotfiles"
BACKUPS="$HOME/.backup/mxt-shell-zsh"

if ! [ -d "$BACKUPS/etc" ]; then
    printf "Creating backup directory in %s\n" "$BACKUPS/etc"
    mkdir -p "$BACKUPS/etc"
fi

# Make system files if we're in cygwin and the files do not exist.

# Be idempotent!

if [[ "$(uname -s)" =~ cygwin ]]; then

    if ! [ -f /etc/passwd ]; then
        printf "Generating /etc/passwd\n"
        mkpasswd -l > /etc/passwd || {
            printf "Looks like we can't create /etc/passwd.\n"
            printf "You'll need to figure out why. Maybe you don't have permissions?\n"
            exit 1
        }
    fi

    if ! [ -f /etc/group ]; then
        printf "Generating /etc/group\n"
        mkgroup -l > /etc/group || {
            printf "Looks like we can't create /etc/group.\n"
            printf "You'll need to figure out why. Maybe you don't have permission?\n"
            exit 1
        }
    fi

    if ! [ -f /etc/nsswitch.conf ]; then
        printf "Generating /etc/nsswitch\n"
        touch /etc/nsswitch.conf || {
            printf "Looks like we can't create /etc/nsswitch.conf.\n"
            printf "You'll need to figure out why. Maybe you don't have permissions?\n"
            exit 1
        }
        install -c $ETCFILES/nsswitch.conf /etc/nsswitch.conf
    fi

    if ! [ -f /etc/shells ]; then
        printf "Generating /etc/shells\n"
        touch /etc/shells || {
            printf "Looks like we can't create /etc/shells.\n"
            printf "You'll need to figure out why. Maybe you don't have permissions?\n"
            exit 1
        }
        printf "# /etc/shells: valid login shells\n" > /etc/shells
        for bindir in bin sbin usr/bin usr/sbin usr/local/bin usr/local/sbin; do
            for shell in sh bash zsh csh tcsh fish ksh nologin dash slsh ash posh scsh; do
                if [ -x "/$bindir/$shell" ]; then
                    printf "/%s/%s\n" "$bindir" "$shell" >> /etc/shells
                fi
            done
        done
    fi

# Now update the files for zsh if they already existed.
# Also, make backups.

    if [ -f /etc/passwd ]; then
        printf "Backing up and updating /etc/passwd\n"
        cp /etc/passwd $BACKUPS/etc/passwd
        sed -i -e 's#/bash#/zsh#' /etc/passwd
    fi

    if [ -f /etc/nsswitch.conf ]; then
        printf "Backing up and updating /etc/nsswitch\n"
        cp /etc/nsswitch.conf $BACKUPS/etc/nsswitch.conf
        sed -i -e 's#/bash#/zsh#' /etc/nsswitch.conf
    fi

    if [ -f /etc/shells ]; then
        printf "Backing up and updating /etc/shells\n"
        cp /etc/shells $BACKUPS/etc/shells
        if [ -x /bin/zsh ] && [ -z "$(grep '/bin/zsh' /etc/shells)" ]; then
            printf "/bin/zsh\n" >> /etc/shells
        fi
        if [ -x /usr/bin/zsh ] && [ -z "$(grep '/usr/bin/zsh' /etc/shells)" ]; then
            printf "/usr/bin/zsh\n" >> /etc/shells
        fi
    fi

else
    # 404 Cygwin not found
    "$SCRIPTROOT/generate_bug_report.sh"
fi

shopt -u nocasematch
