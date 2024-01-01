# dotfiles

These are the dotfiles for my NixOS installations across three computers. I use it primarily to sync declarative settings between three different computers and to track version history.

## Notable features

- Declarative GNOME settings
- Mandatory LUKS encryption
- Dynamic drive UUID storage for LUKS configuration across devices
- pop-shell, i3 styling tiling WM within GNOME + overriding default GNOME keybinds
- Modular home-manager
- Easy syncing between computers using git and relevant scripts

## Installation

- Install the standard GNOME version of NixOS, nothing particularly needed here besides setting username to `mvhove` and encrypting the hard drive with LUKS
- Open a terminal and use `nano` to edit `/etc/nixos/configuration.nix`, find `environment.systemPackages` and add `git` in the square brackets, then save
- Run `sudo nixos-rebuild switch`
- Run `git clone https://github.com/mvhove/dotfiles.git /home/mvhove/.dotfiles`
- Run `cd /home/mvhove/.dotfiles/`
- Run `./install.sh`
- Follow the instructions carefully. You will be prompted at some point for your LUKS device UUID, this can be found by opening a new terminal to run `sudo nano /etc/nixos/configuration.nix.bak`, navigating to the line beginning with `boot.initrd.luks.devices`, and copying the part starred in either `luks-*` or `/dev/disk/by-uuid/*`

## Maintaining

- To grab the latest configuration, run `./home/mvhove/.dotfiles/pull.sh`
- To upload the latest configuration, run `./home/mvhove/.dotfiles/push.sh`