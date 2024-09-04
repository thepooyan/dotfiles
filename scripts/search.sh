query=$(rofi -dmenu -p "Search Google:")

if [ -n "$query" ]; then
  folan=$(echo "$query" | sed 's/ /+/g')
  # xdg-open --new-window "https://www.google.com/search?q=$folan"
  vivaldi --new-window "https://www.google.com/search?q=$folan"
fi
