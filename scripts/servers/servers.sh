#! /bin/bash

servers="/home/pooyan/.password-store/server"

choice=$(ls "$servers" | fzf)

echo connecting to $choice ...

ip=$(pass show server/$choice/ip)
pass=$(pass show server/$choice/pass)
# port

echo $ip
echo $pass


