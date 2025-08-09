These are the dotfiles for my Arch + Hyprland setup. They're not exactly pretty, but I've tried my best to make them look nice and consistent with all the features I actually use.

## Installation

> Note: this will overwrite any conflicting files in your home directory! Run `config checkout` to see which files will be overwritten and back them up before running `config checkout --force`.

```bash
git clone --bare https://github.com/dgrilawidbanana/.dotfiles.git "$HOME/.dotfiles"
alias config='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
config checkout --force
config config --local status.showUntrackedFiles no
~/.dotfiles/install.sh
```

## Usage

```bash
config pull                       # Pull from remote
~/.dotfiles/install.sh            # Install updates
config add .bashrc                # Track a file
config rm --cached .vimrc         # Untrack a file
config status                     # Show local changes
config commit -m "Update bashrc"  # Commit changes
config push                       # Push to remote
```

## Features

- [swww](https://github.com/LGFae/swww)
  - Efficient animated wallpaper daemon
- [Waybar](https://github.com/Alexays/Waybar)
  - System tray, media player controller, clock, and more
- [tofi](https://github.com/philj56/tofi)
  - Fast app launcher and dynamic menu
- [fcitx5](https://github.com/fcitx/fcitx5)
  - Multiple keyboard input support
- [cliphist](https://github.com/sentriz/cliphist)
  - Clipboard history management
- [KeePassXC](https://github.com/keepassxreboot/keepassxc)
  - Password manager and secrets service
- [physlock](https://github.com/dexterlb/physlock/)
  - TTY-style lockscreen
- [Mechvibes Lite](https://github.com/eeriemyxi/mechvibes-lite)
  - Mechanical keyboard sounds
- wallmenu (custom script)
  - System-wide theme and wallpaper selector

## Keyboard shortcuts

### Navigation

_Hold Shift with most of these to move the active window along with you._

| Action                    | Keys                                              |
| ------------------------- | ------------------------------------------------- |
| Cycle focus               | `Alt (+ Shift) + Tab`                             |
| Move focus                | `Super + Arrow Keys`                              |
| Switch workspace          | `Super + Number` or `Super + Ctrl + Left / Right` |
| Scroll through workspaces | `Super + Mouse Scroll`                            |

### Window management

| Action                | Keys                       |
| --------------------- | -------------------------- |
| Toggle fullscreen     | `Super + F`                |
| Toggle floating/tiled | `Super + Ctrl + Up / Down` |
| Toggle pseudo layout  | `Super + P`                |
| Toggle split          | `Super + J`                |

### System controls

| Action              | Keys                |
| ------------------- | ------------------- |
| Lock screen         | `Super + L`         |
| Log out of Hyprland | `Super + Shift + L` |

### Utilities

| Action                              | Keys                |
| ----------------------------------- | ------------------- |
| Switch keyboard input               | `Ctrl + Space`      |
| Open wallpaper menu                 | `Super + T`         |
| Pick color to clipboard             | `Super + C`         |
| Open clipboard history              | `Super + V`         |
| Screenshot region to clipboard      | `Super + S`         |
| Screenshot full screen to clipboard | `Super + Shift + S` |
