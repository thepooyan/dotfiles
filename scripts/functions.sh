#!/bin/bash

tkanata() {
  if systemctl --user is-active --quiet kanata.service; then
    systemctl stop --user kanata.service
  else
    systemctl start --user kanata.service
  fi
}

search() {
  nix-search $1 | less
}

install() {
  nix-env -iA nixpkgs.$1
}

docker_cdi() {
  docker rmi $(docker images -f "dangling=true" -q)
}

shecan() {
  nmcli con mod Salmani_5G ipv4.dns "178.22.122.100 185.51.200.2"
  sudo systemctl restart NetworkManager
}
unshecan() {
  nmcli con mod Salmani_5G ipv4.dns ""
  sudo systemctl restart NetworkManager
}

pooyan() {
  nmcli dev wifi rescan
  nmcli dev wifi connect pooyan password $(pass show wifi/pooyan)
}

in() {
  declare -A colors
  colors=(
    ["red"]='\033[0;31m'
    ["green"]='\033[0;32m'
    ["yellow"]='\033[0;33m'
    ["blue"]='\033[0;34m'
    ["purple"]='\033[0;35m'
    ["cyan"]='\033[0;36m'
    ["white"]='\033[0;37m'
    ["reset"]='\033[0m'
  )

  local color="$1"
  shift
  if [ ! "$@" = "" ];then
    text="$@" 
  else
    read text
  fi
  local color_code="${colors[$color]}"

  if [[ -z "$color_code" ]]; then
    echo "Color not recognized. Available colors: ${!colors[@]}"
    return 1
  fi

  echo -e "${color_code}${text}${colors["reset"]}"
}

run() {
  if [ ! -x $1 ];then
    chmod +x $1
  fi
  ./$1
}

dot() {
  zde dot
}

arti() {
  zde arti
}

mini() {
  zde mini
}

doc() {
  zde Document
}

not() {
  cd notes
  vim 0_start.md

  # after exit

  if git diff --quiet; then
    echo "No differences found"
    return
  fi

  git add .
  git commit -m "$(date +"%D %a %r")"
  git push origin master && {
    echo
      echo push successful!!
    } || {
      echo
      echo push failed!!
    }      
}

vaults() {
  cd "/home/pooyan/0 Pooyan/Obsidian" 
  ar="$(ls | fzf)"
  if [ ! -n "$ar" ]; then
    echo what?
    return
  fi
  cd $ar
  vim .
}

get_pass() {
  pass show $1
}

vim() {
  nvim "$1"
}

ide() {
  cc && nvim .
}

zde() {
  cd $@ 
  nvim .
}

cc() {
  cd "$(fuzzyFindFolder)"
}

fuzzyFindFolder() {
  find . -type d | fzf
}

nekoray() {
  get_pass pass | sudo -S ~/appImages/nekoray/nekoray-3.19-2023-08-30-linux-x64.AppImage
}

obsidian() {
  ~/appImages/Obsidian/Obsidian-1.5.3.AppImage
}

clipboard() {
  [ ! -z "$1" ] && {
    echo "$@" | xclip -selection clipboard
  } || {
    read -r input
      echo "$input" | xclip -selection clipboard
    }
  }

  clickdent() {
    sshpass -p $(get_pass clickdent/pass) ssh -p 8022 $(get_pass clickdent/ip)
  }

  sendTo() {
    sshpass -p "$(get_pass clickdent/pass)" scp -P 8022 $1 $(pass show clickdent/ip):/home/salmani
  }

  viewClipboard() {
    xclip -o -sel clip
  }

  watch() {
    if [ -f $1 ]; then 
      if [ ! -x $1 ];then
        echo making the file executable
        chmod +x $1
      fi
      ls * | entr sh -cc "clear && ./$1"
      return
    fi
    if command -v $1 &> /dev/null;then
      args=$@
      ls * | entr sh -cc "clear;$args"
      return
    fi
    echo arg specified is neither a file or a command
  }

  generate_pacman_logs() {
    grep "pacman -S [a-zA-Z].*" /var/log/pacman.log | awk -F"'" '{print $2}' | awk '!seen[$0]++' | tac | cat
  }

  fm() {
    if [ $1 ]; then
      $FILE_MNGR $1&
    else
      $FILE_MNGR "$(fuzzyFindFolder)"
    fi
  }

  regenerate_spotify() {
    pass remove spoti
    pass generate -c spoti
  }

  zipall() {
    for file in *; do
      if [ -f "$file" ]; then
        zip "${file}.zip" "$file"
      fi
    done
  }
