#!/bin/bash

previous_workspace_file="$HOME/.previous_workspace"
previous_workspace="$(i3-msg -t get_workspaces | jq -r '.[] | select(.visible).num' | xargs)"

i3-msg -t subscribe -m '[ "workspace" ]' | while read line
do
  current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.visible).num' | xargs) 
  if [ "$current_workspace" != "$previous_workspace" ];then
    echo Chnage!
    echo prev: $previous_workspace
    echo curr: $current_workspace
    echo $( $HOME/.config/i3/workspace_diff.sh "$previous_workspace" "$current_workspace") > $previous_workspace_file
    previous_workspace="$current_workspace"
  fi
done

