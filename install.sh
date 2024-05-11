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
    "neovim"
    "exa"
    "entr"
    "ripgrep"
    "zsh"
    "stow"
    "yay"

    # i3
    "i3"
    "arandr"
    "i3-battery-popup"
    "picom"
    "polybar"
    "xbacklight"
    "playerctl"
    "feh"
    "i3lock"
    "rofi"

    # apps
    "firefox-developer-edition"
    "kitty"

    #flatpack
    "flatpack"
)

# sudo pacman -Syu

for app in "${applications[@]}"; do
    sudo pacman -S --noconfirm "$app"
done

# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

stow .
