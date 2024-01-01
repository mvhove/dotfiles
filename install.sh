#!/usr/bin/env bash

echo -e "READ THIS: to ensure shit doesn't go very bad, please manually verify\n - the name of your user is 'mvhove'\n - this is a fresh install of the GNOME version of NixOS\n - you've put 'git' in your current configuration.nix and run 'sudo nixos-rebuild switch'\n\nare you ready? (y/N): "

read -n 1 answer

if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
  echo -e "\ncanceled!"
  exit 1
else
  echo -e "\nstarting..."
fi

echo -e "\ncloning repo..."

git clone https://github.com/mvhove/dotfiles /home/mvhove/.dotfiles

if [ $? -eq 0 ]; then
  echo -e "\ncloned repo!"
else
  echo -e "\nfailed to clone repo!"
  exit 1
fi

echo -e "\nrepo has been pulled successfully"

echo -e "\npreparing to copy system files"

echo -e "\nbacking up existing /etc/nixos/configuration.nix to /etc/nixos/configuration.nix.bak"
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak

sudo cp /home/mvhove/.dotfiles/nixos/configuration.nix /etc/nixos/configuration.nix
echo -e "\ncopied /home/mvhove/.dotfiles/nixos/configuration.nix to /etc/nixos/configuration.nix"

echo -e "\nnow you need to enter the uuid of your luks encrypted hard drive. this can be found by opening /etc/nixos/configuration.nix.bak and copying the value in place of the star in the line related to luks (/dev/disk/by-uuid/*)\n\nenter that value now: "

read -r luksUUID

if [ -n "$luksUUID" ]; then
    echo -e "\nfinding and replacing uuid..."
    sudo sed -i "s/8rYhoqGPLACEHOLDERTTHhAM/$luksUUID/g" "/etc/nixos/configuration.nix"
    echo -e "\nuuid found and replaced!"
else
    echo -e "\ni don't even know how this happened, but something went very wrong"
fi

echo -e "\ndone with configuration.nix, on to flake.nix"

sudo cp /home/mvhove/.dotfiles/nixos/flake.nix /etc/nixos/flake.nix
echo -e "\ncopied /home/mvhove/.dotfiles/nixos/flake.nix to /etc/nixos/flake.nix, now on to home.nix"

sudo cp /home/mvhove/.dotfiles/nixos/home.nix /etc/nixos/home.nix
echo -e "\ncopied /home/mvhove/.dotfiles/nixos/home.nix to /etc/nixos/home.nix, all system files copied now, time to build"

sudo nixos-rebuild switch

echo -e "\npreparing to copy user files"

find /home/mvhove/.dotfiles/mvhove -type f -print0 | while IFS= read -r -d '' file; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    target="/home/mvhove/$filename"

    mkdir -p "$(dirname "$target")"

    if [ -e "$target" ]; then
      echo -e "\nbacking up existing $target to $target.bak"
      sudo mv "$target" "$target.bak"
    fi

    sudo cp "$file" "$target"
    echo -e "\ncopied $file to $target"
  fi
done

echo -e "copying user files complete"

echo -e "\n\ninstallation complete!"

exit 0
