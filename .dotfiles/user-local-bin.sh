# /etc/profile.d/user-local-bin.sh

# When the user logs in, append ~/.local/bin to their path if it exists
[ -d "$HOME/.local/bin" ] && append_path "$HOME/.local/bin"
