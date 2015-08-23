# ZSH Startup Files Explained
Adapted from http://zshwiki.org/home/config/files

## Where are my config files located?

Usually zsh's global config files are located in `/etc` (eg. `/etc/zshrc`) and your personal configs are located in your home directory (eg. `/home/ft/.zshrc`).

However, zsh is very flexible, so the location of the global config files (via compile time options), as well as the personal config files (via `$ZDOTDIR`), may be changed.

Checking `$ZDOTDIR` is easy (and left as an exercise for the reader). Note, if `$ZDOTDIR` isn't set, `$HOME` is the default location for per-user-config files.

Checking for the global location takes a little trick:
```
zsh% strings =zsh | grep zshrc
/etc/zsh/zshrc
.zshrc
```

See? That's the output on a debian System, where the global configs are put in `/etc/zsh/`.

## Login, versus Interactive, versus Script zsh instances


If you do not know what an interactive shell or a login shell is, **please** read [chapter 2 of the users guide](http://zsh.sf.net/Guide/zshguide02.html#l6) (at least 2.1). I know people are impatient, so a here's quick way of testing, if you are in a login shell: 
```
if [[ -o login ]] ; then
  echo login shell
else
  echo _no_ login shell
fi
```

Yes, you can test for interactive shells in the same way.

## When are they read?
There are several types of config files for zsh. For each type there are two files: one global and one per-user file. The global file is read before the per-user one. This listing is in chronological order:

### As a table

| Login Shell | Interactive Shell | Script/Sub-Shell |
| -----------:| -----------------:| ----------------:|
| zshenv      | zshenv            | zshenv           |
| zprofile    |                   |                  |
| zshrc       | zshrc             |                  |
| zlogin      |                   |                  |
| .zshenv     | .zshenv           | .zshenv          |
| .zprofile   |                   |                  |
| .zshrc      | .zshrc            |                  |
| .zlogin     |                   |                  |

### Explained

#### zshenv / .zshenv

`zshenv` is the first file zsh reads; it's read for **every** shell, even if started with `-f` (`setopt NO_RCS`).
`.zshenv` is the same, except that it's **not** read if zsh is started with `-f`.

#### zprofile / .zprofile

`zprofile` is read after `zshenv` if the shell is a **login shell**.

#### zshrc / .zshrc

`zshrc` is read after `zprofile` if the shell is an **interactive shell**.

#### zlogin / .zlogin

`zlogin` is read after `zshrc` if the shell is a **login shell**.
Note that with `zprofile` and `zlogin` you are able to run commands for login shells **before** and **after** `zshrc`.

## Shutdown Files

These are similar to Startup Files, so I'll add them here. Shutdown Files are run when a **login shell** exits. The available files are: `.zlogout` and `zlogout`. Note that for Shutdown files, the **order is different** from Startup files. First the per-user file is read, then the global one.

## Would you like to know more?

[The zsh manpage](http://zsh.sourceforge.net/Doc/Release/Files.html#SEC26)
[The zsh FAQ (q.3.2)](http://zsh.sf.net/FAQ/zshfaq03.html#l19)
[Chapter 2 of the zsh users guide](http://zsh.sf.net/Guide/zshguide02.html#l6)