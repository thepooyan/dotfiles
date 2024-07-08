#!/bin/bash

remove() {
  names=$(pacman -Qq $@ 2>/dev/null)

  if [ -n "$names" ]; then
    sudo pacman -Rns $names
  else
    echo Error! target not found: $@
    exit
  fi 

  breakIfFailed

  removeLogs $names
  echo Removed $names
  commit "Removed $names"
}

install() {
  local temp=false

  if [ $1 = "-t" ]; then
    temp=true  
    shift
  fi

  echo installing $@ ...
  echo
  sudo pacman -S $@

  breakIfFailed

  if [ $temp = true ];then
    saveTemp $@
    commit "Temporarily installed $@"
  else
    savePermanent $@
    commit "Installed $@"
  fi

}

clean() {
  echo removing these packages:
  for i in $(cat $temp_log); do 
    echo - $i
  done
  echo
  breakPrompt
  list=$(tr '\n' ' ' < $temp_log)
  remove $list
  commit "Cleaned packages: $list"
}

list() {
  if [ "$1" = "permanent" ]; then
    bat $permanent_log
  fi
  if [ "$1" = "temp" ]; then
    bat $temp_log
  fi
  if [ "$1" = "all" ] || [ -z "$1" ]; then
    local tmp="$logs_folder/tmp"
    > $tmp
    while read l; do 
      if [ -z "$l" ];then
        break
      fi
      echo \(temp\) $l >> "$tmp"
    done < $temp_log

    bat --file-name "Temp" $tmp --file-name "Permanent" $permanent_log
    rm $tmp
  fi
}

update() {
  sudo pacman -Syu
}

sync() {
  echo installing these packages:
  to_install=()

  for i in $(cat $permanent_log); do 
    if ! pacman -Qq $i > /dev/null 2>&1; then
      echo - $i
      to_install+=("$i")
    fi
  done
  joined_string=$(IFS=" "; echo "${to_install[*]}")

  echo
  breakPrompt
  install $joined_string
}

edit() {
  vim $permanent_log
}

git() {
  /usr/bin/git $@
}

restore() {
  if [ -d "$logs_folder" ];then
    echo There is already a logs folder in this address:
    echo $logs_folder
    echo
    echo Remove or rename it before trying to clone another one
    exit
  fi

  echo cloning @1
}

init() {
  mkdir $logs_folder
  touch $permanent_log
  touch $temp_log
  echo Creating folder $logs_folder 
  echo Creating $temp_log
  echo Creating $permanent_log
  echo Welcome to upm!
  cd $logs_folder
  git init
  git add .
  git commit -m "Initial commit"
}
