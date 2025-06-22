# variables
uptime="$(uptime -p | sed -e 's/up //g')"
shutdown='  shutdown'
reboot='󰜉  reboot'
lock='󰌾  lock'
suspend='󰒲  suspend'
logout='󰍃  logout'

chosen=$(printf "%s\n%s\n%s\n%s\n%s" "$shutdown" "$reboot" "$suspend" "$logout" "$lock" | rofi -dmenu -p "Uptime: $uptime" -theme-str 'window {width: 14em;} listview {lines: 5;}')

case $chosen in
    "$shutdown") systemctl poweroff ;;
    "$reboot") systemctl reboot ;;
    "$lock") loginctl lock-session ;;
    "$suspend") systemctl suspend ;;
    "$logout") hyprctl dispatch exit ;;
    *) exit 1 ;;
esac
