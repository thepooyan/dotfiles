#!/bin/bash
background() {
  local script_dir="/home/pooyan/dotfiles/scripts/background"
  # Navigate the the scripts's directory
  cd $script_dir

  back_loc="$(cat .conf/location)"
  store="$back_loc/.current" 
  prev=$(cat $store)
  target="$prev"

  if [ ! -f $store ]; then
    touch $store
  fi

  next() {
    f() {
      ls -1 $back_loc
      ls -1 $back_loc
    }

    found=false
    for i in $(f); do 
      if [ "$found" = "true" ]; then
        target="$i"
        break
      fi

      if [ "$i" = "$prev" ]; then
        found=true
      fi
    done

    apply
  }

  random() {

    while [ "$target" = "$prev" ]
    do
      target=$(ls "$back_loc" | shuf -n 1)
    done

    apply
  }

  apply() {
    echo from: $prev
    echo to: \  $target

    echo $target > $store
    feh --bg-scale "$back_loc/$target"
  }

  if [ -z "$1" ]; then
    echo no args...
    return
  fi

  if ! declare -F "$1" > /dev/null; then
    echo what is $1 ? ://
    return
  fi

  $1
}

_background() { 
  compadd next random 
} 

compdef _background background
