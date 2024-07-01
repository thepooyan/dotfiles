back_loc="/home/pooyan/Pictures/backgrounds"
store="$back_loc/.current" 
prev=$(cat $store)
target="$prev"

if [ ! -f $store ]; then
  touch $store
fi

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

echo from: $prev
echo to: $target

echo $target > $store
feh --bg-scale "$back_loc/$target"
