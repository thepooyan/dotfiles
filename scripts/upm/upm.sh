#!/bin/bash

logs_folder="/home/pooyan/.upm"
main_log="$logs_folder/main_log.txt" 
permanent_log="$logs_folder/permanent_log.txt" 

if [ ! -d "$logs_folder" ];then
  mkdir $logs_folder
  echo Creating folder $logs_folder 
fi

install() {
  local temp=false

  if [ $1 = "-t" ]; then
    temp=true  
    shift
  fi

  echo installing $@ ...
  echo
  sudo pacman -S $1

  if [ ! $? -eq 0 ]; then
    exit
  fi

  savelog $1
  if [ $temp != true ];then
    savePermanent $1
  fi
}

savelog() {
  echo $1 >> $main_log
}

savePermanent() {
  echo $1 >> $permanent_log
}

if ! declare -F "$1" > /dev/null; then
  echo what is $1 ? ://
  exit
fi

command=$1
shift
$command $@
