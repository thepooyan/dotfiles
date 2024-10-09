#!/bin/bash
prefix=/home/pooyan/dotfiles/scripts

source $prefix/background/background.sh
alias logger="~/dotfiles/scripts/logger.sh"
alias boot="~/dotfiles/scripts/boot.sh"
alias theme="~/dotfiles/scripts/theme.sh"

alias cls=clear
alias vi="/usr/bin/vim"
alias hibernate="systemctl hibernate"
alias cat=bat
alias ls="eza --icons --git"
alias lh="eza --icons --git -l"
alias tree="eza --tree"
alias upm="/home/pooyan/dotfiles/scripts/upm/upm.sh"

export PATH="$HOME/appImages:$PATH"
