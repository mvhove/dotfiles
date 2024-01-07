#!/usr/bin/env bash

echo -e "\npulling changes from git..."

git pull || { echo -e "\nfailed to pull changes from git!"; exit 1; }

echo -e "\nbacking up system files..."

sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
sudo mv /etc/nixos/home.nix /etc/nixos/home.nix.bak
sudo mv /etc/nixos/flake.nix /etc/nixos/flake.nix.bak

echo -e "\ncopying system files..."

sudo cp /home/mvhove/.dotfiles/nixos/configuration.nix /etc/nixos/configuration.nix
sudo cp /home/mvhove/.dotfiles/nixos/home.nix /etc/nixos/home.nix
sudo cp /home/mvhove/.dotfiles/nixos/flake.nix /etc/nixos/flake.nix

echo -e "\nsetting luks uuid..."

luksUUID=$(cat ".luksUUID.option")
sudo sed -i "s/PLACEHOLDER/$luksUUID/g" /etc/nixos/configuration.nix

echo -e "\nrebuilding..."

sudo nixos-rebuild switch || handle_error "\nfailed to rebuild!"
