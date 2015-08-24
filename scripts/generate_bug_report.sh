#!/usr/bin/env bash
shopt -s nocasematch

BUG_URL="https://github.com/padthaitofuhot/mxt-shell-zsh/issues"

# Generate bugreport info if we need it
cyg_info() {
    for envar in CYGWIN MOBASTARTUPDIR SESSIONNAME HOME VERSION DISPLAY; do
        set | grep -a "^${envar}="
    done
    ls -l /etc/custom.* /etc/persistprofile.sh /etc/version/ $(which uname) $(which bash)
    cygcheck -c | grep -v OK
    cygcheck -s 2>/dev/null | grep -A16 "Cygwin DLL version info"
}

printf "PROBLEM: This system does not appear to be Cygwin.\n"
printf "If this really is Cygwin or an embedded Cygwin (eg. MobaXTerm),\n"
printf "please check for (and file) a bug report with the properties:\n\n"
printf "### Title:\nUndetected Cygwin: %s\n\n" "$(uname -s)"
printf "### Body:\n"
cyg_info | sed -e "s#`whoami`#sanitized#g" -e "s#`groups $(whoami) | cut -d ' ' -f 1`#sanitized#g"
printf "\n"
printf "Issue Tracker: %s\n\n" "$BUG_URL"
printf "Thank you and good luck.\n"
