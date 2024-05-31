#!/bin/bash
second_monitor() {
  [[ ! -z $(inxi -aG | grep Monitor-2) ]]
}

if second_monitor; then
  xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off --output HDMI-1-1 --mode 1920x1080 --pos 1920x0 --rotate normal
else 
  echo second monitor not found
fi
