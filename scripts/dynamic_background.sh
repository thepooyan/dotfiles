back_loc="/home/pooyan/Pictures/backgrounds/"

target=$(ls "$back_loc" | shuf -n 1)

echo $target

feh --bg-scale "$back_loc$target"
