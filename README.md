# Yet another home folder keeper

This one is for my own use, I advice you to
[check out better and tested versions](http://dotfiles.github.com/)
instead.

Setup is not tested beyond bootstrapping my own few shells.

## Principles and differences to other dotfile-keepers

* Home folder is a git work tree, so no linking of files
* Git-dir is named as `~/.homekeeper`, so regular `git`-command does not detect it and is safe to use
* `homekeeper.sh` (at your $PATH) passes arguments to `git` using `~/.homekeeper` as git-dir
 * Use familiar git-commands to control your files
* By default everything is ignored at `~/.gitignore`
 * `homekeeper status` shows just changes to tracked files (no clutter of 34832 untracked files)
 * Use `homekeeper add -f` to add new files
* Few internal commands like `homekeeper ls` to list tracked files
* `homekeeper init` to begin (does ginit init, creates ignorefile and setups origin)

Use at your own risk!

```
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
```
