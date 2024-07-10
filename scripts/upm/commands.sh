#!/bin/bash

remove() {
  remove_cmd $@

  breakIfFailed

  removeLogs $@
  echo Removed $@
  commit "Removed $@"
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

  saveGen $@
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

    cat $tmp $permanent_log | bat --file-name "Packages"
    rm $tmp
  fi
}

update() {
  sudo pacman -Syu
}

sync() {
  to_remove=$(diff $gen_log $permanent_log | grep "^<" | sed 's/< //g')

  if [ -n "$to_remove" ];then
    echo removing these packages:
    echo

    for l in $to_remove;do
      echo - $l | echoin red
    done
  fi

  echo

  to_install=()
  for i in $(cat $permanent_log); do 
    if ! pacman -Qq $i > /dev/null 2>&1; then
      to_install+=("$i")
    fi
  done

  if [ -n "$to_install" ];then
    echo installing these packages:
    echo
    for i in $to_install; do 
      echo - $i | echoin green
    done
  fi

  if [ -z "$to_install" ] && [ -z "$to_remove" ];then
    echo already up to date!
    exit
  fi

  echo
  breakPrompt

  [ -n "$to_remove" ] && remove_cmd --noconfirm $to_remove
  [ -n "$to_install" ] && install_cmd --noconfirm $to_install
}

edit() {
  if [ "$1" == "temp" ];then
    vim $temp_log
  else
    vim $permanent_log
  fi
  echo
  echo changes:
  echo

  git diff --unified=0 --no-prefix | grep -E '^[+]\w' | echoin green
  git diff --unified=0 --no-prefix | grep -E '^[-]\w' | echoin red

  prompt "Save the changes?" && {
    commit "Manual change"
      echo
      echo run \"upm sync\" to apply the changes to your system
      exit
    }
    git restore .
    echo 
    echo restoring the changes...
  }


  restore() {
    if [ -d "$logs_folder" ];then
      echo There is already a logs folder in this address:
      echo $logs_folder
      echo
      echo Remove or rename it before trying to clone another one
      exit
    fi

    mkdir ~/.upm
    git clone $1 ~/.upm
    if [ $? != "0" ]; then
      rmdir ~/.upm
    fi
  }

  init() {
    mkdir $logs_folder
    cd $logs_folder
    touch $permanent_log
    touch $temp_log
    touch $gen_log
    echo all_log.txt > .gitignore
    echo Creating folder $logs_folder 
    echo Creating $temp_log
    echo Creating $permanent_log
    echo Welcome to upm!
    cd $logs_folder
    git init
    git add .
    git commit -m "Initial commit"
  }

