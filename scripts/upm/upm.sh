#!/bin/bash

logs_folder="/home/pooyan/.upm"

temp_log="$logs_folder/temp_log.txt" 
permanent_log="$logs_folder/permanent_log.txt" 

if [ ! -d "$logs_folder" ];then
  mkdir $logs_folder
  echo Creating folder $logs_folder 
fi

breakIfFailed() {
  if [ ! $? -eq 0 ]; then
    exit
  fi
}

remove() {
  sudo pacman -Rns $1

  breakIfFailed

  removeLog $1
  echo Removed $1
}

install() {
  local temp=false

  if [ $1 = "-t" ]; then
    temp=true  
    shift
  fi

  echo installing $1 ...
  echo
  sudo pacman -S $1

  if [ ! $? -eq 0 ]; then
    exit
  fi

  if [ $temp = true ];then
    saveTemp $1
  else
    savePermanent $1
  fi
}

saveTemp() {
  saveLog $1  $temp_log
}

savePermanent() {
  saveLog $1 $permanent_log
}

saveLog() {
  remove $1
  echo $1 >> $2
}

removeLog() {
  sed -i '/\b'$1'\b/d' $temp_log
  sed -i '/\b'$1'\b/d' $permanent_log
}

if ! declare -F "$1" > /dev/null; then
  echo what is $1 ? ://
  exit
fi

command=$1
shift
$command $@
