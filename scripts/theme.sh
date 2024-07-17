pic="/home/pooyan/dotfiles/.config/picom/picom.conf"

op() {
  apply 90 17
}

vivid() {
  apply 95 3
}

normal() {
  apply 90 7.5
}

classy() {
  apply 85 7
}

see_through() {
  apply 80 4
}

if ! command -v $1 &> /dev/null;then
  echo $1 not defined...
  exit
fi

apply() {
  sed -i '/tmux/c\  "'$1':name *= '\''tmux'\'' && focused",' $pic
  sed -i '/^blur-strength.*/c\blur-strength = '$2';' $pic
}

$1
