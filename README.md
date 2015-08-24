# mxt-shell-zsh
A set of scripts and utilities to help switch MobaXTerm's local shell to zsh (or anything, really) and replace MobaXTerm's unique bash scripts with zsh functional equivalents.

## What's the problem?

[MobaXTerm](http://mobaxterm.mobatek.net/), also known as MXT, is a splendidly amazing tool from the French company MobaTek. It is a multi-protocol, tabbed, mostly-open-source Windows Delphi program for remote access. It supports SSH, MoSH, RDP, and many others. Of relevance to this repo is that MXT contains an embedded Cygwin x86 instance. The default local shell is bash4, and MobaTek's treatment of the bash4 environment is as pragmatic as it is beautiful, and demonstrates the cross-platform intelligence MobaTek brings to bear on MXT as a solid product. If you just want a fast, local, light-duty Cygwin, the default MobaXTerm is the right way to go. If you're like me and can't leave well-enough alone, however, you will quickly discover that the default login shell is not configurable, so we can't make zsh our shell. *Until now...*

## What mad science is this?

***For starters, we are gleefully touching important system files!*** Under MobaXterm (and some cygwin installs) /etc/shells does not exist. We'll create one of those too if we need to, otherwise update it. Cygwin in general [lacks a chsh](https://github.com/robbyrussell/oh-my-zsh/issues/3588), so we work around that updating /etc/passwd by hand or generating one if it doesn't exist. We'll do the same for /etc/nsswitch.conf.

***We are adding and changing shell profile files!*** Since MXT does not include zsh, we have to set up all of the zsh environment files for the login, interactive, and script shell invocations. This repo in particular seeks to set up a zsh environment at least as Quality as MobaTek's, and the basis of that road is... Undecided.
    The popular [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) framework?
    The less bloated antigen?
    A faster antigen rethink like antigen-hs?
    Holman's topical dotfiles setup?

***We are also installing unsigned code from dubious sources!*** Under MobaXTerm the default login shell CANNOT be changed ([as of version 8.1](http://blog.mobatek.net/)) through the normal means every *nix nerd in the last 20+ years has come to expect from a unix-like environment. MobaXTerm is hard-coded to invoke bash.exe as the local cygwin shell, so if you really want zsh as your default we have have to work around that by changing the cygtermd.exe MobaXTerm uses to invoke the login shell. Read on for more info.

There is, of course, no guarantee, that any of this will work. It may very well detroit your MobaXTerm installation and sell your loved-ones into slavery. But it works great for me in MobaXTerm 8.1 Pro under Windows 7 x64. Obviously, YMMV.

## This sounds like a terrible idea?

I'm doing this because I'm a snob and prefer zsh over bash. I'm not willing to give up MobaXTerm, and MobaXTerm has not yet provided a supported path for changing the default login shell.

## How does one force MXT to respect the shell in /etc/passwd?

So the deal is, MobaXTerm invokes bash from its own PuTTY codebase they call "MoTTY". MoTTY calls Simon Tatham's cygtermd.exe, which is a telnet-to-pty proxy originally intended for running Cygwin sessions within PuTTY. MobaXTerm hard-codes the MoTTY session call to cygtermd.exe via a randomly-named tmp file every time it's called, and the shell's path is always set to /bin/bash.exe. Right?

Since we are prohibited by MobaXTerm's licenses (pro users only) from modifying the un-upx'd MobaXTerm runtime with a hex editor (*cough*bvi*cough*), we work around the problem with a modified version of cygtermd.exe patched thusly:

1. Ignore the shell command line argument to cygtermd
2. Ignore the SHELL environment variable
3. Go straight to /etc/passwd to find the user's configured shell.
4. Pass any other command line arguments given to cygtermd right to whatever shell we picked out, because "-l -i" are supported by most shells I like using anyway.

*Oh, the things we do for love...*

## A patched cygtermd
In src/cygtermd is a copy of Simon Tatham's cygtermd.exe source code. It has been modified to respect the contents of /etc/passwd, or, failing that, fall back to /bin/sh. It simply replaces the command line argument it's given as the requested shell with the contents of the user's /etc/passwd line.

## A replacement shell profile


## An installer for the whole shebang


### Steps involved
* Generate /etc/passwd, /etc/group, and /etc/nsswitch.conf if they don't already exist
* Update the above files to point the local console login shell for your user account to /bin/zsh
* 

# Known issues

1. Any updates to the zsh package through the Cygwin setup*.exe program will no longer update /etc/zprofile
2. The MXT /etc/custom.profile will not be loaded
3. 
