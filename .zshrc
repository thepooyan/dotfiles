FILE_MNGR=dolphin
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
autoload -Uz compinit && compinit

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zinit light zsh-users/zsh-autosuggestions

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# zinit snippets (from oh my zsh)
# zinit snippet OMZP::git
# zinit snippet OMZP::sudo
# zinit snippet OMZP::archlinux
# zinit snippet OMZP::aws
# zinit snippet OMZP::kubectl
# zinit snippet OMZP::kubectx
# zinit snippet OMZP::command-not-found

# My config

alias cls=clear
alias vi="/usr/bin/vim"
alias hibernate="systemctl hibernate"
alias cat=bat
alias ls=exa
alias tree="eza --tree"
alias logger="~/dotfiles/scripts/logger.sh"
alias boot="~/dotfiles/scripts/boot.sh"

get_pass() {
  pass show $1
}

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
  get_pass pass | sudo -S ~/appImages/nekoray/nekoray-3.19-2023-08-30-linux-x64.AppImage
}

obsidian() {
  ~/appImages/Obsidian/Obsidian-1.5.3.AppImage
}

clipboard() {
  read -r input
  echo "$input" | xclip -selection clipboard
}

clickdent() {
  sshpass -p $(get_pass clickdent_pass) ssh -p 8022 $(get_pass clickdent_ip)
}

sendTo() {
  sshpass -p "$(get_pass clickdent_pass)" scp -P 8022 $1 salmani@00000000:/home/salmani
}

viewClipboard() {
  xclip -o -sel clip
}

watch() {
  ls * | entr sh -cc "clear && ./$1"
}

generate_pacman_logs() {
  grep "pacman -S [a-zA-Z].*" /var/log/pacman.log | awk -F"'" '{print $2}' | awk '!seen[$0]++' | cat
}

fm() {
  if [ $1 ]; then
    $FILE_MNGR $1&
  else
    $FILE_MNGR "$(fuzzyFindFolder)"
  fi
}

set -o vi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey -r viins '\ec'

eval "$(zoxide init --cmd cd zsh)"

eval "$(starship init zsh)"
