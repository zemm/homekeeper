# Yet another home folder keeper

## Motivation and differences to other dotfile-keepers

* Proxy for Git; familiar commands, no new things to learn
* Git-dir is located at `~/.homekeeper`, so regular `git`-commands are not affected and should be safe to use
* Your home folder is a git work tree: no linking of files
or install scripts. Files versioned in their original locations.
* By default everything is ignored at `~/.gitignore`
 * Avoids cluttering `homekeeper status` with thousands of files
 * Explicit tracking of selected files with `homekeeper add -f`
* `homekeeper ls` alias to show what is being tracked

Use at your own risk (I have been for many years)!

## 2.0: A Slimmed down Version

Old `homekeeper` worked the same way, but has cumbersome and
unnecessarily complex init. I replaced it with a help text hint
of a one way to do it.

### Installation

#### Option a) a bash script

Download the script to your PATH:

```
cd ~/bin
wget https://raw.githubusercontent.com/zemm/homekeeper/master/homekeeper
chmod o+x homekeeper
```

#### Option b) slim barebones version

Just add these to your ~/.bashrc or other rc file:
```
alias homekeeper='git --git-dir="${HOME}/.homekeeper" --work-tree="${HOME}"'
alias homekeeper-ls='git --git-dir="${HOME}/.homekeeper" --work-tree="${HOME}" ls-tree -r --name-only HEAD "${HK_WORK_TREE}"'
```

### Setup and usage

#### Preparations

Create your remote bare dotfiles repo somewhere (github?)"

#### Initialization

Do this on every machine where you want your dotfiles to be managed

```
$ homekeeper init
$ homekeeper remote add origin DOTFILES_REPO_URL
```

#### With empty / freshly created dotfiles repo

On a first machine, create an ignorefile to ignore everything by
default. We want to only manage explicit files, obviously not our
home dir as a whole.

```
$ echo '*' >> ~/.gitignore
$ homekeeper add --force ~/.gitignore
$ homekeeper commit -m "Ignore everything by default; be explicit"
$ homekeeper push origin master
```

#### With existing dotfiles repo

- **Warning** Assert your dotfiles repo has the above `.gitignore`!
- **WARNING** this is a destuctive operation that **will overwrite** local files that exist in the dotfiles repo!

```
$ homekeeper pull origin master
$ homekeeper checkout --force master
```

#### Daily usage

Use as you would git, just use `homekeeper` instead of `git`.
Add new files with `homekeeper add --force MY_FILE`.

```
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
```
