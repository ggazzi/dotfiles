## Strategy

All necessary information for properly using Atom is in its configuration files. Most of them are relatively independent of the environment (e.g. no references to specific files or directories). All such files are kept in the `config` subdirectory, and symlinks to them are put into atom's configuration directory.

Installed packages are backed up using `package-sync`, which syncronized the installed packages using the file `packages.cson`.

In order to __setup a freshly installed atom__, `scripts/setup-atom.sh` should be used.
