#!/bin/bash

dot() {
  zde dot
}

min() {
  zde mini
}

doc() {
  zde Document
}

tod() {
  zde todo
}

vaults() {
  cd "/home/pooyan/0 Pooyan/Obsidian" 
  ar="$(ls | fzf)"
  if [ ! -n "$ar" ]; then
    echo what?
    return
  fi
  cd $ar
  vim .
}
  
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
 cd $@ 
 nvim .
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
  [ ! -z "$1" ] && {
    echo "$@" | xclip -selection clipboard
  } || {
    read -r input
    echo "$input" | xclip -selection clipboard
  }
}

clickdent() {
  sshpass -p $(get_pass clickdent_pass) ssh -p 8022 $(get_pass clickdent_ip)
}

sendTo() {
  sshpass -p "$(get_pass clickdent_pass)" scp -P 8022 $1 $(pass show clickdent_ip):/home/salmani
}

viewClipboard() {
  xclip -o -sel clip
}

watch() {
  ls * | entr sh -cc "clear && ./$1"
}

generate_pacman_logs() {
  grep "pacman -S [a-zA-Z].*" /var/log/pacman.log | awk -F"'" '{print $2}' | awk '!seen[$0]++' | tac | cat
}

fm() {
  if [ $1 ]; then
    $FILE_MNGR $1&
  else
    $FILE_MNGR "$(fuzzyFindFolder)"
  fi
}

regenerate_spotify() {
  pass remove spoti
  pass generate -c spoti
}

zipall() {
  for file in *; do
    if [ -f "$file" ]; then
      zip "${file}.zip" "$file"
    fi
  done
}
