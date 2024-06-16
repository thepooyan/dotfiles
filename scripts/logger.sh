#!/bin/bash

logs_folder="/home/pooyan/dotfiles/scripts/Logs/"

if [ ! -d $logs_folder ]; then
  echo Logs folder not found, creating one in $logs_folder
  mkdir $logs_folder
fi

if [ -z "$1" ]; then
  echo No args specifed
  exit 1
fi

echo running $1 with logs...
logs_file="$logs_folder$1.logs"

if [ ! -f "$logs_file" ];then
  echo log file created: $logs_file
fi

echo _______________________________________ >> "$logs_file"
echo Date: $(date) >> "$logs_file"
echo Logs: >> "$logs_file"
echo "" >> "$logs_file"
./$1 >> "$logs_file" 2>&1

