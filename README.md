These are the dotfiles for my Arch + Hyprland setup. It's currently minimal (read: unstyled) but feature-complete enough for daily use—at least for me.

## Installation

```bash
git clone --bare https://github.com/dgrilawidbanana/.dotfiles.git $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config checkout
config config --local status.showUntrackedFiles no
sudo ~/.dotfiles/install.sh
```

## Usage

```bash
config pull                       # Sync with remote
config add .bashrc                # Stage a file
config rm .vimrc                  # Stop tracking a file
config status                     # View local changes
config commit -m "Update bashrc"  # Commit the change
config push                       # Push to remote
```
