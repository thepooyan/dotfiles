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

saveTemp() {
  saveLog $1  $temp_log
}

savePermanent() {
  saveLog $1 $permanent_log
}

saveLog() {
  removeLog $1
  echo $1 >> $2
}

removeLog() {
  sed -i '/\b'$1'\b/d' $temp_log
  sed -i '/\b'$1'\b/d' $permanent_log
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

  breakIfFailed

  if [ $temp = true ];then
    saveTemp $1
  else
    savePermanent $1
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
   cat $permanent_log
 fi
 if [ "$1" = "temp" ]; then
   cat $temp_log
 fi
 if [ "$1" = "all" ] || [ -z "$1" ]; then
   while read l; do 
     echo \(temp\) $l
   done < $temp_log
   cat $permanent_log
 fi
}

if ! declare -F "$1" > /dev/null; then
  echo what is $1 ? ://
  exit
fi

command=$1
shift
$command $@
