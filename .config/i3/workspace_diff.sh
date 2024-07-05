#!/bin/bash

first_string="$1"
second_string="$2"

  # Convert the strings into arrays
  read -r -a first_array <<< "$first_string"
  read -r -a second_array <<< "$second_string"

  # Iterate over the first array and check if elements are not in the second array
  for num in "${first_array[@]}"; do
    if ! [[ " ${second_array[@]} " =~ " $num " ]]; then
      echo "$num"
    fi
  done
