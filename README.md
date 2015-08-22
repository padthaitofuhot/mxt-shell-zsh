# mxt-shell-zsh
A set of scripts and utilities to help switch MobaXTerm's local shell to zsh and replace MobaTek's bash scripts.

## The problem

[MobaXTerm](http://mobaxterm.mobatek.net/), a splendidly amazing tool from the French company MobaTek, is a multi-protocol, tabbed, mostly-open-source Delphi program for Windows that contains an embedded Cygwin x86 instance. This is most excellent. However, the default local shell is bash4 and is not configurable, so we can't make zsh our default login shell. *Until now...*

## What mad science are we doing here?

***For starters, we are gleefully touching important system files!*** Under MobaXterm (and some cygwin installs) /etc/shells does not exist. We'll create one of those too if we need to, otherwise update it. Cygwin in general lacks a chsh, so we work around that updating /etc/passwd by hand or generating one if it doesn't exist. We'll do the same for /etc/nsswitch.conf.

***We are also installing unsigned code from dubious sources!*** Under MobaXTerm the default login shell CANNOT be changed (as of version 8.1) through the normal means every *nix nerd in the last 20+ years has come to expect from a unix-like environment. MobaXTerm is hard-coded to invoke bash.exe as the local cygwin shell, so if you really want zsh as your default we have have to work around that by changing the cygtermd.exe MobaXTerm uses to invoke the login shell. Read on for more info.

There is, of course, no guarantee, that any of this will work. It may very well detroit your MobaXTerm installation and sell your loved-ones into slavery. But it works great for me in MobaXTerm 8.1 Pro under Windows 7 x64. Obviously, YMMV.

## This sounds like a terrible idea, why are you doing it?

I'm doing this because I'm a snob and prefer zsh over bash. I'm not willing to give up MobaXTerm, and MobaXTerm has not yet provided a supported path for changing the default login shell.

## What's up with that anyway?

So the deal is, MobaXTerm invokes bash from its own PuTTY codebase they call "MoTTY". MoTTY calls Simon Tatham's cygtermd.exe, which is a telnet-to-pty proxy originally intended for running Cygwin sessions within PuTTY. MobaXTerm hard-codes the MoTTY session call to cygtermd.exe via a randomly-named tmp file every time it's called, and the shell's path is always set to /bin/bash.exe. Right?

Since we are prohibited by MobaXTerm's licenses (pro users only) from modifying the un-upx'd MobaXTerm runtime with a hex editor (*cough*bvi*cough*), we work around the problem with a modified version of cygtermd.exe patched thusly:

1. Ignore the shell command line argument to cygtermd
2. Ignore the SHELL environment variable
3. Go straight to /etc/passwd to find the user's configured shell.
4. Pass any other command line arguments given to cygtermd right to whatever shell we picked out, because "-l -i" are supported by most shells I like using anyway.

## DISCLAIMER OF LIABILITY

**THERE IS NO GUARANTEE OF ANY KIND, WARRANTY OF ANY KIND, NOR ANY OTHER INDICATION, EXPRESSED OR IMPLIED, THAT THIS PROCEDURE WILL PRODUCE A NET POSITIVE OUTCOME. IT MAY VERY WELL CAUSE YOUR MOBAXTERM INSTALLATION TO BREAK, LOSE DATA, OR OTHERWISE SEND YOU INTO THE HOWLING FANTODS OF REMORSE AND REGRET. YOU HAVE BEEN SO WARNED. BY EXECUTING THIS SCRIPT YOU CONSENT TO WHATEVER OUTCOME MAY ARISE FROM ITS EXECUTION, AND AGREE THAT BY EXECUTING THIS SCRIPT YOU ARE IN LEGAL FACT CONSENTING TO THE EXECUTION OF THIS SCRIPT AT YOUR OWN RISK AND PERIL, SO HELP YOU GOD, HOWEVER YOU DO OR DO NOT CONCEIVE IT TO BE.  THIS DISCLAIMER MAY BE SUPERSEDED BY, DEPRECATED BY, OR OTHERWISE OVERRIDDEN BY THE MUCH BETTER WRITTEN DISCLAIMER OF LIABILITY CONTAINED WITHIN THE ACTUAL SOFTWARE LICENSE WHICH CAN BE FOUND IN THE LICESNSE FILE AT THE PROJECT ROOT.**

*Oh, the things we do for love...*

## .... to do.......

## A patched cygtermd


## A replacement shell profile


## An installer for the whole shebang

### Steps involved
* Generate /etc/passwd, /etc/group, and /etc/nsswitch.conf if they don't already exist
* Update the above files to point the local console login shell for your user account to /bin/zsh
* 