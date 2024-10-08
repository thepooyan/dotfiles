#!/bin/bash

package_installed_msg() {
  echo This pakcage is already installed.
  echo
  echo if you wish to add a package that\'s already installed to your lists, try using these commands:
  echo
  echo \"upm permanent [package]\" | echoin blue
  echo \"upm temp [package]\" | echoin blue
}

find_in_aur() {
  yay -Ss $1 | grep "aur/$1 "
}

find_in_official() {
  result=$(pkgfile -s "$1")
  count=$(echo $result | wc -w)

  if [ -z "$result" ];then
    echo no match found for \"$i\" in regular repositories
    exit 1
  fi

  if [ "$count" == "1" ];then
    echo $result | sed 's/^.*\///'
  else
    level2=$(echo "$result" | grep ".*/$1")
    if [ "$(echo $level2 | wc -w)" == "1" ];then
      echo $level2 | sed 's/^.*\///'
    else
      echo "$result" | fzf | sed 's/^.*\///'
    fi
  fi
}

checkforconflicts() {
  conflicts=$(grep -Fxf $temp_log $permanent_log)
  if [ -z "$conflicts" ];then
    return
  fi

  echo Error! | echoin red
  echo these packages are listed both under permanent and temp: 
  echo
  for i in $conflicts; do
    echo - $i | echoin red
  done
  echo
  echo packages cannot be in both lists.
  echo
  echo \"upm temp [package name]\" | echoin blue
  echo to move a package to the temp list
  echo
  echo \"upm permanent [package name]\" | echoin blue
  echo to move a package to the permanent list
  echo

  press_any_key 
  vim $1

  checkforconflicts $1
}

package_installed() {
  pacman -Qq $@ > /dev/null 2>&1
}

press_any_key() {
  echo ${1:-"Press any key to continue..."}
  read -n 1 -s -r
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
    if ! grep "$i" $gen_log > /dev/null;then
      echo $i >> $gen_log
    fi
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
