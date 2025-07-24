#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Installation requires root privileges, re-running with sudo..."
  exec sudo /bin/bash "$0" "$@"
fi

SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

pacman -Syu
pacman -S brightnessctl cliphist dolphin fastfetch fuzzel hypridle hyprland hyprpaper hyprpicker hyprpolkitagent hyprshot keepassxc kitty mako micro noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra physlock-dexterlb-git pipewire-pulse qt5-wayland ttf-font-awesome vivaldi waybar wireplumber wtype xdg-desktop-portal-gtk xdg-desktop-portal-hyprland

ln -fs "${SCRIPT_DIR}/physlock.service /etc/systemd/system/physlock.service"
systemctl daemon-reload
systemctl enable physlock.service
