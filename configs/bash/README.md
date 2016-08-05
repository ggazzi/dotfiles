The bashrc file is kept in this repository, and `~/.bashrc` is a symlink to it.

In order to support machine-specific configuration, such as changes to the `$PATH`, all files in the directory `~/.bashrc.d` are sourced by `.bashrc`.
