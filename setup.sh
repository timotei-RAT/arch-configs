#!/bin/bash
echo "Installing base system"
sudo pacman -Sy base-devel emacs i3-gaps figlet 
sudo pacman -Syyu
echo "Checking gcc and make version.."
gcc -v
make -v
echo "Installing DOOM emacs"
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
