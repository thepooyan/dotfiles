#!/bin/bash

logs_folder="/home/pooyan/.upm"
script_folder="/home/pooyan/dotfiles/scripts/upm"

temp_log="$logs_folder/temp_log.txt" 
permanent_log="$logs_folder/permanent_log.txt" 

if [ ! -d "$logs_folder" ];then
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
fi

cd $logs_folder

source "$script_folder/commands.sh"

if ! declare -F "$1" > /dev/null; then
  echo what is $1 ? ://
  exit
fi

source "$script_folder/util.sh"

command=$1
shift
$command $@
