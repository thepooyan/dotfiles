#!/bin/bash

install_cmd() {
  sudo pacman -S --noconfirm $@
}

remove_cmd() {
  flags=""
  if [ "$1" = "--noconfirm" ];then
    flags+="--noconfirm"
    shift
  fi
  names=$(pacman -Qq $@ 2>/dev/null)

  if [ -n "$names" ]; then
    sudo pacman -Rs $flags $names
  else
    echo Error! target not found: $@
    exit
  fi 
}

echoin() {
  declare -A colors
  colors=(
    ["red"]='\033[0;31m'
    ["green"]='\033[0;32m'
    ["yellow"]='\033[0;33m'
    ["blue"]='\033[0;34m'
    ["purple"]='\033[0;35m'
    ["cyan"]='\033[0;36m'
    ["white"]='\033[0;37m'
    ["reset"]='\033[0m'
  )

  local color="$1"
  read text
  local color_code="${colors[$color]}"

  if [[ -z "$color_code" ]]; then
    echo "Color not recognized. Available colors: ${!colors[@]}"
    return 1
  fi

  echo -e "${color_code}${text}${colors["reset"]}"
}

commit() {
  git add .

  date="$(date +"%D %a %r")"
  join=$(printf "%s, " "$@")
  join=${join%, }
  massage="[ $date ] - $join"

  git commit -m "$massage"
}

commandExists() {
  if command -v $1 &> /dev/null; then
    echo 0
  else
    echo 1
  fi
}

breakIfFailed() {
  if [ ! $? -eq 0 ]; then
    exit
  fi
}

saveGen() {
  for i in $@; do 
    echo $i >> $gen_log
  done
}

saveTemp() {
  saveLog $temp_log "$@"
}

savePermanent() {
  saveLog $permanent_log "$@"
}

saveLog() {
  local log=$1
  shift
  for i in $@; do 
    saveSingleLog $log $i
  done
}

saveSingleLog() {
  removeLog $2
  echo $2 >> $1
}

removeLog() {
  sed -i '/\b'$1'\b/d' $temp_log
  sed -i '/\b'$1'\b/d' $permanent_log
  sed -i '/\b'$1'\b/d' $gen_log
}

removeLogs() {
  for i in $@; do 
    removeLog $i
  done
}

breakPrompt() {
  while true; do
    read -p "Do you want to proceed? (Y/n): " yn
    yn=${yn:-y}
    case $yn in
      [Yy]* ) break;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}

prompt() {
  while true; do
    read -p "$1 (Y/n): " yn
    yn=${yn:-y}
    case $yn in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}
