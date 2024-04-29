#!/bin/bash


applications=(
    # codeing
    "node"
    "npm"
    "git"
    "code"
    "nvim"

    # terminal
    "tmux"
    "zoxide"
    "bat"
    "fzf"
    "vim"
    "exa"
    "ripgrep"
    "zsh"
    "stow"

    # i3
    "i3"
    "arandr"
    "i3-battery-popup"
    "picom"
    "xbacklight"
    "playerctl"
    "feh"
    "i3lock"
    "rofi"

    # apps
    "firefox-developer-edition"
    "google-chrome-stable"
    "kitty"
    ""
    ""
)

# sudo pacman -Syu

for app in "${applications[@]}"; do
    sudo pacman -S --noconfirm "$app"
done

# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

stow .
