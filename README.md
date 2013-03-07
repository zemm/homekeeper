# Yet another home folder keeper

This one is for my own use, I advice you to
[check out better and tested versions](http://dotfiles.github.com/)
instead.

Setup is not tested beyond bootstrapping my few own shells.

## Differences to other dotfile-keepers

* Home folder is a git work tree, so no linking of files
* Git-dir is located at `~/.homekeeper`, so `git`-command does not detect it and is safe to use
* `homekeeper.sh` (to be placed at your $PATH) passes undetected arguments to `git` with `~/.homekeeper` as git-dir
 * Use familiar git-commands to control your files
* By default everything is ignored at `~/.gitignore`
 * `homekeeper status` shows just changes to tracked files (no clutter of 34832 untracked files)
 * Use `add -f` to add new files
* Few buildin commands like `homekeeper ls` to list versioned files

Use at your own risk!

```
Copyright © 2000 zemm <zemm@iki.fi>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
```
