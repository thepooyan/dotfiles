#!/bin/bash

# File to store the previous workspace
previous_workspace_file="$HOME/.previous_workspace"

# Get the current active workspace
current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

# If the file exists, read the previous workspace from the file
if [ -f "$previous_workspace_file" ]; then
    previous_workspace=$(cat "$previous_workspace_file")

    if [ "$previous_workspace" != "$current_workspace" ]; then
      # echo "$previous_workspace"
      echo "$previous_workspace"
    fi
fi
