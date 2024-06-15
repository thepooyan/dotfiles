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
    # jdk

    # terminal
    "jq"
    "xclip"
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
    "mlocate"

    # i3
    "i3"
    "arandr"
    "i3-battery-popup"
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

cd ..
stow .
