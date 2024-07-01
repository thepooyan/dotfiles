back_loc="/home/pooyan/Pictures/backgrounds"
store="$back_loc/.current" 
prev=$(cat $store)
target="$prev"

if [ ! -f $store ]; then
  touch $store
fi

while [ "$target" = "$prev" ]
do
  target=$(ls "$back_loc" | shuf -n 1)

  echo from: $prev
  echo to: $target


  echo $target > $store

done

feh --bg-scale "$back_loc/$target"
