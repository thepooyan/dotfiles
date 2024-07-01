back_loc="/home/pooyan/Pictures/backgrounds"
store="$back_loc/.current" 
prev=$(cat $store)
target="$prev"

if [ ! -f $store ]; then
  touch $store
fi


next() {
  f() {
    ls -1 $back_loc
    ls -1 $back_loc
  }

  found=false
  for i in $(f); do 
    if [ "$found" = "true" ]; then
      target="$i"
      break
    fi

    if [ "$i" = "$prev" ]; then
      found=true
    fi
  done

  apply
}

random() {

  while [ "$target" = "$prev" ]
  do
    target=$(ls "$back_loc" | shuf -n 1)
  done

  apply
}

apply() {
  echo from: $prev
  echo to: $target

  echo $target > $store
  feh --bg-scale "$back_loc/$target"
}

if [ -z "$1" ]; then
  echo no args...
  exit
fi

if ! declare -F "$1" > /dev/null; then
  echo what is $1 ? ://
  exit
fi

$1
