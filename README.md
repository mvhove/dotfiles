# dotfiles

These are the dotfiles for my NixOS installations across three computers. I use it primarily to sync declarative settings between three different computers and to track version history.

## Notable features

- Declarative GNOME settings
- Support for LUKS encryption
- Dynamic drive UUID storage for LUKS configuration
- pop-shell, i3 styling tiling wm within GNOME + overriding default GNOME keybinds
- Modular home-manager
- Easy syncing between computers using git

## Installation

- Install the standard GNOME version of NixOS, nothing particularly needed here besides setting username to `mvhove` and encrypting the hard drive with LUKS
- Open 
- Open a terminal and run `./home/mvhove/.dotfiles/install.sh`
- Follow the instructions carefully

## Maintaining

- To grab the latest configuration, run `./home/mvhove/.dotfiles/pull.sh`
- To upload the latest configuration, run `./home/mvhove/.dotfiles/push.sh`