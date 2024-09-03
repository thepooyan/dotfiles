#!/bin/bash
direction=$1
current=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused).num') 
isMatrix=false

if [ $current -gt 10 ]; then
  isMatrix=true
  current_Y=$((current / 10))
  current_X=$((current % 10))
fi

workspace_exists() {
  test=$(i3-msg -t get_workspaces | jq '.[] | select(.num == '$1')')
  if [[ -z "$test" ]];then
    echo false
  else
    echo true
  fi
}

if [[ $isMatrix = true ]]; then
  if [[ $direction == left ]]; then
    echo 5
  fi
  if [[ $direction == right ]]; then
    echo 6
  fi
else 
  if [[ $direction == left ]]; then
    if [[ $current == 1 ]];then 
      exit
    fi
    try=$((current-1))
    while [[ "$(workspace_exists $try)" == "false" ]]; do
      try=$((try-1))
      if [[ "$try" == "0" ]];then
        exit
      fi
    done

    echo $try
    exit
  fi
  if [[ $direction == right ]]; then
    if [[ $current == 10 ]];then 
      exit
    fi
    try=$((current+1))
    while [[ "$(workspace_exists $try)" == "false" ]]; do
      try=$((try+1))
      if [[ "$try" == "11" ]];then
        exit
      fi
    done
    echo $try
    exit
  fi
fi
