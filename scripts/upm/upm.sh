#!/bin/bash

logs_folder="/home/pooyan/.upm"
script_folder="/home/pooyan/dotfiles/scripts/upm"

temp_log="$logs_folder/temp_log.txt" 
permanent_log="$logs_folder/permanent_log.txt" 
gen_log="$logs_folder/all_log.txt" 

if [ ! -d "$logs_folder" ] && [ "$1" != "init" ] && [ "$1" != "restore" ];then
  echo upm has not been initialized yet!
  echo
  echo run \"upm init\" to initialize a new repository,
  echo ro run \"upm restore [your_git_repository_address]\" to restore your repo.
  exit
fi

[ -d "$logs_folder" ] && cd $logs_folder

source "$script_folder/commands.sh"

if [ "$1" == "git" ]; then
  $@
  echo 
  echo It is recommended to run
  echo    \"upm sync\"
  echo after EVERY manual change to the repository,
  echo so that upm\'s inner log get\'s updated with the latest changes
  exit
fi

if ! declare -F "$1" > /dev/null; then
  echo what is $1 ? ://
  exit
fi

source "$script_folder/util.sh"

echo
$@
