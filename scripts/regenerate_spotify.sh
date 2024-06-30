#!/bin/bash

echo Are you sure?
read ans

if [[ $ans != "y" ]]; then
  exit
fi

pass remove spoti
pass generate -c spoti

