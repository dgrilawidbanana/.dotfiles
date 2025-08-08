#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ -z "$SSH_CONNECTION" ]] && [[ -z "$DISPLAY" ]] && [[ -z "$WAYLAND_DISPLAY" ]] && [[ $(tty) == "/dev/tty1" ]]; then
	exec hyprland > /dev/null
fi
