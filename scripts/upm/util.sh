#!/bin/bash

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
