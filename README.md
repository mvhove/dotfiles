# dotfiles

These are the dotfiles for my NixOS installations across three computers. I use it primarily to sync declarative settings between three different computers and to track version history.

## Notable features

- Declarative GNOME settings
- Support for LUKS encryption
- Dynamic drive UUID storage for LUKS configuration
- Modular home-manager
- Easy syncing between computers using git

## Installation

- Install the standard GNOME version of NixOS, nothing particularly needed here besides setting username to `mvhove` and encrypting the hard drive with LUKS
- Open a terminal and run `./home/mvhove/.dotfiles/install.sh`
- Follow the instructions carefully

## Maintaining

- Open a terminal and run `./home/mvhove/.dotfiles/update.sh`
