#!/usr/bin/env bash

echo -e "READ THIS: to ensure shit doesn't go very bad, please manually verify\n - the name of your user is mvhove\n - this is a fresh install of the GNOME version of NixOS\n\nare you ready? (y/N): "

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

echo -e "\nnow you need to enter the uuid of your luks encrypted hard drive. this can be found by opening /etc/nixos/configuration.nix and copying the value in place of the star in the line related to luks (/dev/disk/by-uuid/*)\n\nenter that value now: "

read -r luksUUID

if [ -n "$luksUUID" ]; then
    echo -e "\nsaving uuid..."
    echo "$luksUUID" | sudo tee /home/mvhove/.dotfiles/nixos/luks.uuid > /dev/null
    echo -e "\nuuid saved to /home/mvhove/.dotfiles/nixos/luks.uuid"
else
    echo -e "\ni don't even know how this happened, but something went very wrong"
fi

echo -e "\npreparing to symlink system files"

for file in "/home/mvhove/.dotfiles/nixos/"*; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    target="/etc/nixos/$filename"

    if [ -e "$target" ]; then
      echo -e "\nbacking up existing $target to $target.bak"
      mv "$target" "/etc/nixos/$target.bak"
    fi

    ln -s "$file" "$target"
    echo -e "\ncreated symlink between $file and $target"
  fi
done

echo -e "\nsymlinking complete, preparing to build nixos config"

sudo nixos-rebuild switch

echo -e "\npreparing to symlink user files"

for file in "/home/mvhove/.dotfiles/mvhove/"*; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    target="/home/mvhove/$filename"

    if [ -e "$target" ]; then
      echo -e "\nbacking up existing $target to $target.bak"
      mv "$target" "/etc/nixos/$target.bak"
    fi

    ln -s "$file" "$target"
    echo -e "\ncreated symlink between $file and $target"
  fi
done

find /home/mvhove/.dotfiles/mvhove -type f -print0 | while IFS= read -r -d '' file; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    target="/home/mvhove/$filename"

    mkdir -p "$(dirname "$target")"

    if [ -e "$target" ]; then
      echo -e "\nbacking up existing $target to $target.bak"
      mv "$target" "/home/mvhove/$target.bak"
    fi

    ln -s "$file" "$target"
    echo -e "\ncreated symlink between $file and $target"
  fi
done

echo -e "symlinking complete"

echo -e "\n\ninstallation complete!"

exit 0
