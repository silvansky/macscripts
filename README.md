# macscripts - my collection of useful OS X scripts for bash

When I come to problem that can be solved with shell scripting, I put a solution here. Feel free to fork and modify my code.

## Some explanations

`.gitconfig` - my config for `git`. All my favorite aliases live here.

`.profile` - bash profile, common defines, functions, etc, for bash. I use zsh for now, but I really call this file from `.zshrc`.

`.zshrc` - zsh settings.

`build_gcc.sh`å - script for building gcc 4.7 for OS X.

`convert_video_4_ios.sh` - script for converting any video to iOS-compatible format (mpeg4/aac). This script uses `ffmpeg` for real work. As an arguments, pass list of files to convert (for example, `./convert_video_4_ios.sh *.avi`). Resulting filenames are the same as in input, but with .mp4 extension.

`gitcb.sh` - when called from git repository, outputs current branch name. If you are in detached head state, it outputs empty string.

`gpull.sh` - alias for `git pull origin $@`.

`gpullcb.sh` - alias for `gpull.sh $(gitcb.sh)`.

`gpush.sh` - alias for `git push origin $@`.

`gpushcb.sh` - alias for `gpush.sh $(gitcb.sh)`.

`installable.sh` - exports list of scripts to be installed in `/usr/local/bin`.

`installscripts.sh` - installs some scripts in `/usr/local/bin` (as symlinks without .sh)

`make_dmg.sh` - highly customizable utility for creating .dmg image from an application. See [http://habrahabr.ru/post/152677/](http://habrahabr.ru/post/152677/) for more information (in russian) or use `make_dmg.sh -h` for short help message.

`openrandom.sh` - opens random file from current directory (recursive) with `open` command. This script uses my [randstr](https://github.com/silvansky/randstr) command line tool.

`svn-changes.sh` - script for creating html report from `svn diff`. Uses [diff2html.py](http://wiki.droids-corp.org/index.php/Diff2html).

`svn-log.sh` - simple tool for browsing svn log.

Really, I don't use svn anymore, so these scripts are subject to remove.

`toggle_finder_show_hidden.sh` - toggles OS X Finder's "show hidden files" option.

`uninstallscripts.sh` - removes all scripts installed by `installscripts.sh`.
