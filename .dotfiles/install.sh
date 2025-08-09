#!/usr/bin/env bash
set -e

if [[ $EUID == 0 ]]; then
	echo "Do not run this script as root (e.g., with sudo)"
	exit 1
fi

script_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

printf "\e[1;32m[*]\e[0m Starting full system upgrade\n"
sudo pacman -Syu --noconfirm

if ! command -v yay &> /dev/null; then
	printf "\e[1;32m[*]\e[0m Installing yay AUR helper\n"
	temp_dir="$(mktemp -d)"
	sudo pacman -S --needed --noconfirm git base-devel
	git clone https://aur.archlinux.org/yay.git "$temp_dir"
	pushd "$temp_dir"
	makepkg -si
	popd
	rm -rf "$temp_dir"
fi

printf "\e[1;32m[*]\e[0m Installing necessary packages\n"
yay -Syu --noconfirm --removemake
yay -S --needed --noconfirm --removemake archlinux-xdg-menu brightnessctl cliphist dolphin fastfetch fcitx5-im fcitx5-rime hypridle hyprland hyprpicker hyprpolkitagent hyprshot keepassxc kitty mako micro noto-fonts-cjk noto-fonts-emoji noto-fonts-extra nsxiv pavucontrol physlock-dexterlb-git pipewire-pulse power-profiles-daemon pyenv qt5-wayland swww tk tofi ttf-jetbrains-mono vivaldi waybar wireplumber woff2 woff2-font-awesome xdg-desktop-portal-gtk xdg-desktop-portal-hyprland

printf "\e[1;32m[*]\e[0m Adding ~/.local/bin to default path\n"
sudo ln -fs "$script_dir/user-local-bin.sh" /etc/profile.d/user-local-bin.sh
source /etc/profile

printf "\e[1;32m[*]\e[0m Setting up physlock\n"
sudo ln -fs "$script_dir/physlock.service" /etc/systemd/system/physlock.service
sudo systemctl daemon-reload
sudo systemctl enable physlock.service

printf "\e[1;32m[*]\e[0m Allowing any user to lock the screen with physlock without a password\n"
sudo install -Dm440 /dev/stdin /etc/sudoers.d/physlock <<EOF
## Allow any user to lock the screen with physlock without a password
ALL ALL=NOPASSWD: /usr/bin/systemctl start physlock
EOF

printf "\e[1;32m[*]\e[0m Initializing pyenv\n"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

printf "\e[1;32m[*]\e[0m Installing Python and Mechvibes Lite\n"
pyenv install -s 3
pyenv global 3
pip install --upgrade pip
pip install git+https://github.com/eeriemyxi/mechvibes-lite

if id inputrunner &> /dev/null; then
	printf "\e[1;32m[*]\e[0m Adding user 'inputrunner' to group 'input'\n"
	sudo usermod -m -d /home/inputrunner -s /usr/bin/bash -c "Input device access user" -aG input inputrunner
else
	printf "\e[1;32m[*]\e[0m Creating system user 'inputrunner'\n"
	sudo useradd -r -m -d /home/inputrunner -s /usr/bin/bash -c "Input device access user" -G input inputrunner
fi

printf "\e[1;32m[*]\e[0m Allowing any user to traverse to '$script_dir/inputrunner.bashrc'\n"
dir="$script_dir"
while [[ "$dir" != "/" ]]; do
	sudo chmod o+x "$dir"
	dir="$(dirname "$dir")"
done

printf "\e[1;32m[*]\e[0m Creating .bashrc for inputrunner from '$script_dir/inputrunner.bashrc'\n"
sudo ln -sf "$script_dir/inputrunner.bashrc" /home/inputrunner/.bashrc

printf "\e[1;32m[*]\e[0m Installing Python and Mechvibes Lite for inputrunner\n"
sudo -iu inputrunner bash -ci '
pyenv install -s 3;
pyenv global 3;
pip install --upgrade pip;
pip install git+https://github.com/eeriemyxi/mechvibes-lite;
'

printf "\e[1;32m[*]\e[0m Setting up Mechvibes Lite config\n"
sudo ln -sf "$HOME/.config/mechvibes-lite/" /etc/mechvibes-lite
sed -Ei "/^\[wskey]/,/^\[/{s/^(event_id[[:space:]]*=[[:space:]]*)[[:digit:]]+/\1$(grep -A5 keyboard /proc/bus/input/devices | grep -Pom1 'event\K[0-9]+')/}" "$HOME/.config/mechvibes-lite/config.ini"

printf "\e[1;32m[*]\e[0m Allowing any user to start Mechvibes Lite's wskey server daemon as inputrunner without a password\n"
sudo install -Dm440 /dev/stdin /etc/sudoers.d/mechvibes-lite <<EOF
## Allow any user to start Mechvibes Lite's wskey server daemon as inputrunner without a password
ALL ALL=(inputrunner) NOPASSWD: /home/inputrunner/.pyenv/shims/mvibes wskey daemon
EOF

printf "\e[1;32m[*]\e[0m Decompressing WOFF2 fonts to TTF\n"
shopt -s nullglob
sudo install -d /usr/share/fonts/TTF/
for file in /usr/share/fonts/WOFF2/*.woff2; do
	sudo woff2_decompress "$file";
	sudo mv "/usr/share/fonts/WOFF2/$(basename "$file" .woff2).ttf" /usr/share/fonts/TTF/
done
fc-cache -fv

printf "\e[1;32m[*]\e[0m Setting GTK system scheme to light\n"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
gsettings set org.gnome.desktop.interface gtk-theme 'Default'

swww-daemon &> /dev/null & sleep 0.2
if [[ $(swww query) != *"image"* ]]; then
	printf "\e[1;32m[*]\e[0m Setting random wallpaper\n"
	wallpapers=("$HOME/Pictures/wallpapers/light"/*)
	swww img "${wallpapers[RANDOM % ${#wallpapers[@]}]}"
fi

printf "\e[1;32m[*]\e[0m Installation complete. You may need to re-login for some changes to take effect.\n"
