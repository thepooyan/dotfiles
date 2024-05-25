#!/bin/bash
applications=(
    # codeing
    "nodejs"
    "npm"
    "git"
    "code"
    "nvim"
    "go"
    "mariadb"

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
    "sshpass"

    # i3
    "i3"
    "arandr"
    "i3-battery-popup"
    # "picom"
    "polybar"
    "xbacklight"
    "playerctl"
    "feh"
    "i3lock"
    "rofi"

    # apps
    "firefox-developer-edition"
    "kitty"

    #flatpak
    "flatpak"

    #fyne
    "xorg-server-devel"
    "libxcursor"
    "libxrandr"
    "libxinerama"
    "libxi"
)

sudo pacman -S --needed base-devel
sudo pacman -Syu

# for app in "${applications[@]}"; do
#     sudo pacman -S --noconfirm "$app"
# done
sudo pacman -S --noconfirm "$applications"

# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

stow .
