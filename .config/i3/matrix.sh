#!/bin/bash
direction=$1
current=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused).num') 
isMatrix=false

if [ $current -gt 10 ]; then
  isMatrix=true
  current_Y=$((current / 10))
  current_X=$((current % 10))
fi

get_workspace_num() {
  case $1 in
    up)
      echo 12
      ;;
    down)
      echo 32
      ;;
    left)
      echo 21
      ;;
    right)
      echo 23
      ;;
    *)
      echo 22
      ;;
  esac
}

if [[ $isMatrix = true ]]; then
  if [[ $direction == up ]]; then
    dy=$((current_Y-1))
    if ((dy < 1)); then
      dy=3
    fi
    echo dest: $dy$current_X
    i3-msg workspace number $dy$current_X
  fi
  if [[ $direction == down ]]; then
    dy=$((current_Y+1))
    if ((dy > 3)); then
      dy=1
    fi
    echo dest: $dy$current_X
    i3-msg workspace number $dy$current_X
  fi
  if [[ $direction == left ]]; then
    dx=$((current_X-1))
    if ((dx < 1)); then
      dx=3
    fi
    echo dest: $current_Y$dx
    i3-msg workspace number $current_Y$dx
  fi
  if [[ $direction == right ]]; then
    dx=$((current_X+1))
    if ((dx > 3)); then
      dx=1
    fi
    echo dest: $current_Y$dx
    i3-msg workspace number $current_Y$dx
  fi
else 
  i3-msg workspace number $(get_workspace_num $direction)
fi
