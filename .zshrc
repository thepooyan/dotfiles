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

func="/home/pooyan/dotfiles/scripts/functions.sh"
[ -f $func ] && source $func

my_scripts="/home/pooyan/dotfiles/source_my_scripts.sh"
[ -f $my_scripts ] && source $my_scripts

set -o vi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey -r viins '\ec'

eval "$(zoxide init --cmd cd zsh)"

eval "$(starship init zsh)"
