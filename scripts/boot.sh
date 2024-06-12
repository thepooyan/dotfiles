#!/bin/bash

# turn caps lock into another escape 
setxkbmap -option caps:escape

# add persian
setxkbmap -layout us,ir
setxkbmap -option 'grp:ctrl_alt_toggle'
