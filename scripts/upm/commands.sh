#!/bin/bash

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

install() {
  local temp=false
  local flags=""

  if [ $1 = "-t" ]; then
    temp=true  
    shift
  fi

  if [ $1 = "--noconfirm" ];then
    flags+="--noconfirm"
    shift
  fi

  if package_installed $@; then
    package_installed_msg
    exit
  fi

  echo installing $@ ...
  echo
  sudo pacman -S $flags $@

  if [ ! $? -eq 0 ]; then
    echo checking yay repository for $@... | echoin blue
    if find_in_aur $1;then
      echo found the package above
      echo \| Warning!!! | echoin yellow
      echo \| beware you are installing this package via aur | echoin yellow
      echo \| not all of the aur packages are safe | echoin yellow
      echo \| continue with at your risk | echoin yellow

      yay -S $@
      breakIfFailed
    else
      echo Target not found in yay repository either! :\(
      exit
    fi
  fi


  if [ $temp = true ];then
    saveTemp $@
    commit "Temporarily installed $@"
  else
    savePermanent $@
    commit "Installed $@"
  fi

  saveGen $@
}

remove() {
  flags=""
  if [ "$1" = "--noconfirm" ];then
    flags+="--noconfirm"
    shift
  fi
  names=$(pacman -Qq $@ 2>/dev/null)

  if [ -z "$names" ]; then
    echo Error! target not found: $@
    exit
  fi 

  sudo pacman -Rs $flags $names
  breakIfFailed

  removeLogs $@
  removeLogs $names
  echo Removed $@
  commit "Removed $@"
}

clean() {
  echo removing these packages:
  for i in $(cat $temp_log); do 
    echo - $i | echoin red
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
  to_remove=$(diff $gen_log <(cat $permanent_log $temp_log) | grep "^<" | sed 's/< //g')

  if [ -n "$to_remove" ];then
    echo removing these packages:
    echo

    for l in $to_remove;do
      echo - $l | echoin red
    done
  fi

  echo

  to_install=()
  to_install_tmp=()
  for i in $(cat $permanent_log); do 
    if ! pacman -Qq $i > /dev/null 2>&1; then
      to_install+=("$i")
    fi
  done

  for i in $(cat $temp_log); do 
    if ! pacman -Qq $i > /dev/null 2>&1; then
      to_install_tmp+=("$i")
    fi
  done

  if [ -n "$to_install" ] || [ -n "$to_install_tmp" ];then
    echo installing these packages:
    echo
    for i in $to_install $to_install_tmp; do 
      echo - $i | echoin green
    done
  fi

  if [ -z "$to_install_tmp" ] && [ -z "$to_install" ] && [ -z "$to_remove" ];then
    echo already up to date!
    exit
  fi

  echo
  breakPrompt

  [ -n "$to_remove" ] && remove --noconfirm $to_remove
  [ -n "$to_install" ] && install --noconfirm $to_install
  [ -n "$to_install_tmp" ] && install -t --noconfirm $to_install_tmp
}

edit() {
  local targetfile
  if [ "$1" == "temp" ];then
    targetfile=$temp_log
  else
    targetfile=$permanent_log
  fi

  vim $targetfile

  if [ "$(git diff --raw)" != "" ];then
    checkforconflicts $targetfile
    echo committing the changes...
    commit "Manual change"
    echo
    echo run \"upm sync\" to apply the changes to your system
  else
    echo no changes detected...
  fi
}

permanent() {
  if ! package_installed $@; then
    echo package not found: $@
    exit
  fi
  echo Add package\(s\) to permanent: $@
  removeLogs $@
  savePermanent $@
  saveGen $@
  commit "Add package(s) to permanent: $@"
}

temp() {
  if ! package_installed $@; then
    echo package not found: $@
    exit
  fi
  echo Add package\(s\) to temp: $@
  removeLogs $@
  saveTemp $@
  saveGen $@
  commit "Add package(s) to temp: $@"
}
