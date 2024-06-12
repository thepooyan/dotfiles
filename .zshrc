ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
# zinit light zsh-users/zsh-completions
# autoload -Uz compinit && compinit

zinit light zsh-users/zsh-autosuggestions

# My config
[ -f ./pass.sh ] && source ./pass.sh

alias cls=clear
alias vi="/usr/bin/vim"
alias hibernate="systemctl hibernate"
alias cat=bat
alias ls=exa
alias tree="exa --tree"

vim() {
	nvim "$1"
}

ide() {
	cc && nvim .
}

zde() {
 cd $@ && nvim .
}

cc() {
	cd "$(fuzzyFindFolder)"
}

fuzzyFindFolder() {
	find . -type d | fzf
}

nekoray() {
  echo $PASS | sudo -S ~/appImages/nekoray/nekoray-3.19-2023-08-30-linux-x64.AppImage
}

obsidian() {
  ~/appImages/Obsidian/Obsidian-1.5.3.AppImage
}

clipboard() {
  read -r input
  echo "$input" | xclip -selection clipboard
}

clickdent() {
  sshpass -p $CLICKDENT ssh -p 8022 $CLICKDENT_IP
}

fm() {
  if [ $1 ]; then
    dolphin $1&
  else
    dolphin "$(find . -type d | fzf)"&
  fi
}

set -o vi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(zoxide init --cmd cd zsh)"

eval "$(starship init zsh)"
