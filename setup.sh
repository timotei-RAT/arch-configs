#!/bin/bash

handle_error() {
  echo "Error: $1"
  exit 1
}

confirm() {
  read -p "$1 (y/n): " answer
  [ "$answer" == "y" ] || { echo "Operation aborted."; exit 0; }
}

install_yay() {
  echo "Installing yay"
  sudo pacman -S --needed git base-devel || handle_error "Failed to install prerequisites for yay"
  git clone https://aur.archlinux.org/yay.git || handle_error "Failed to clone yay repository"
  cd yay || handle_error "Failed to enter yay directory"
  makepkg -si || handle_error "Failed to install yay"
  cd - || handle_error "Failed to return to the previous directory"
  echo "yay installed successfully."
}

base_packages="base-devel emacs i3-gaps figlet"
additional_repos=("wireshark-qt" "nmap" "burp-suite" "thc-hydra" "gotop")
doom_emacs_repo="https://github.com/doomemacs/doomemacs"

echo "Installing base system"
sudo pacman -Sy $base_packages || handle_error "Failed to install base system"
echo "Base system installed successfully."

confirm "Do you want to update the system?"
echo "Updating system"
sudo pacman -Syyu || handle_error "Failed to update system"
echo "System updated successfully."

echo "Checking gcc and make version.."
gcc -v && make -v || handle_error "Error checking gcc and make versions"

install_yay

# Install additional repositories with yay
for repo in "${additional_repos[@]}"; do
  confirm "Do you want to install $repo with yay?"
  echo "Installing $repo"
  yay -S $repo || handle_error "Failed to install $repo with yay"
  echo "$repo installed successfully."
done

confirm "Do you want to install DOOM Emacs?"
echo "Installing DOOM Emacs"
git clone --depth 1 $doom_emacs_repo ~/.config/emacs || handle_error "Failed to clone DOOM Emacs repository"
~/.config/emacs/bin/doom install || handle_error "Failed to install DOOM Emacs"
echo "DOOM Emacs installed successfully."

echo "Script executed successfully."


