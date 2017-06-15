# Guilherme Azzi's Arch Linux Configuration and Utilities

This repository contains my configuration files for arch linux, as well as
utilities for setting it all up.

It is composed of the following subdirectories:

  - `custom-packages` contains some useful unpublished PKGBUILDS

  - `desktop-environment` contains utilities for managing the desktop
    environment and its configuration

  - `dotfiles` contains user configuration files managed by stow

  - `setup-scripts` makes it faster to configure a fresh installation of arch
    linux

## Desktop Environment

Contains tools for backing up and restoring dconf settings. They require the
following dependencies:

 - [inisort](github.com/ggazzi/inisort)
 - pyyaml, which can be installed with `pip install --user pyyaml`

Its subdirectory `config` contains the backed-up ini files.

## Dotfiles

The user configuration files contained under `dotfiles/` should be managed by
stow. Each subdirectory of `dotfiles` contains a group of related configuration
files, e.g. all files for a particular application, or for a programming
language.

In order to install a set of configuration files, run `stow -t ~ GROUP_NAME`
inside `dotfiles`.

In order to remove a set of configuration files, run `stow -t ~ -D GROUP_NAME`
inside `dotfiles`.

## Setup Scripts

A lot of manual configuration tasks are automated by the scripts inside
`setup-scripts`. These will install packages, enable services, setup
configuration files... All such scripts should be executed from the
`setup-scripts` directory.
