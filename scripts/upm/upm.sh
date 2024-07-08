#!/bin/bash

logs_folder="/home/pooyan/.upm"

temp_log="$logs_folder/temp_log.txt" 
permanent_log="$logs_folder/permanent_log.txt" 

if [ ! -d "$logs_folder" ];then
  mkdir $logs_folder
  echo Creating folder $logs_folder 
fi

if [ ! -f "$permanent_log" ]; then
  touch $permanent_log
  echo Creating $permanent_log
fi

if [ ! -f "$temp_log" ]; then
  touch $temp_log
  echo Creating $temp_log
fi

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

remove() {
  sudo pacman -Rns $@

  breakIfFailed

  removeLogs $@
  echo Removed $@
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
  else
    savePermanent $@
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
  fi
}

update() {
  sudo pacman -Syu
}

sync() {
  echo installing these packages:
  for i in $(cat $permanent_log); do 
    echo - $i
  done
  echo
  breakPrompt
  list=$(tr '\n' ' ' < $permanent_log)
  install $list
}

edit() {
  vim $permanent_log
}

if ! declare -F "$1" > /dev/null; then
  echo what is $1 ? ://
  exit
fi

command=$1
shift
$command $@
