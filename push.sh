#!/usr/bin/env bash

echo -e "\nbacking up system files..."

sudo mv /home/mvhove/.dotfiles/nixos/configuration.nix /home/mvhove/.dotfiles/nixos/configuration.nix.bak
sudo mv /home/mvhove/.dotfiles/nixos/home.nix /home/mvhove/.dotfiles/nixos/home.nix.bak
sudo mv /home/mvhove/.dotfiles/nixos/flake.nix /home/mvhove/.dotfiles/nixos/flake.nix.bak

echo -e "\ncopying system files..."

sudo cp /etc/nixos/configuration.nix /home/mvhove/.dotfiles/nixos/configuration.nix
sudo cp /etc/nixos/home.nix /home/mvhove/.dotfiles/nixos/home.nix
sudo cp /etc/nixos/flake.nix /home/mvhove/.dotfiles/nixos/flake.nix

echo -e "\nsetting uuid placeholder..."

luksUUID=$(cat ".luksUUID.option")
sudo sed -i "s/$luksUUID/PLACEHOLDER/g" /home/mvhove/.dotfiles/nixos/configuration.nix

echo -e "\nadding files to git..."

git add .

echo -e "\nadding files to git..."

read -p "\nEnter your commit message: " commit_message

echo -e "\ncommitting..."

git commit -m "$commit_message"

echo -e "\npushing..."

git push
