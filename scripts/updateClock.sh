#!/bin/bash

update_time() {
  # Check if the system clock has been synchronized already
  if timedatectl status | grep -q "Network time on: yes"; then
    echo "System clock already synchronized via network time protocol (NTP)."
    exit 0
  fi

  # Check if the system is connected to the internet
  if ! ping -c 1 google.com &> /dev/null; then
    echo "No internet connection detected. Exiting."
    exit 1
  fi

  # Synchronize the system clock using systemd-timesyncd
  echo "Synchronizing system clock using systemd-timesyncd..."
  timedatectl set-ntp true

  # Check if synchronization was successful
  if timedatectl status | grep -q "Network time on: yes"; then
    echo "System clock synchronized successfully."
  else
    echo "Failed to synchronize system clock."
    exit 1
  fi

  exit 0
}

echo "watching for internet..."
if ping -c 1 google.com &> /dev/null; then
  echo "connection already exists"
  update_time
  exit 0
fi

nmcli monitor | while read -r line; do
# Check if the line contains information about a new connection
if [[ $line == *"connected"* ]]; then
  echo "connection detected!"
  update_time
fi
done
