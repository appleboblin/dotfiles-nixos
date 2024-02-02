# variables
uptime="$(uptime -p | sed -e 's/up //g')"
shutdown=' shutdown'
reboot=' reboot'
hibernate='⏼ hibernate'
lock=' lock'
suspend='󰏤 suspend'
logout='󰍃 logout'

chosen=$(printf "%s\n%s\n%s\n%s\n%s\n%s" "$shutdown" "$reboot" "$hibernate" "$suspend" "$logout" "$lock" | rofi -dmenu -p "Uptime: $uptime")

case $chosen in
    "$shutdown") systemctl poweroff ;;
    "$reboot") systemctl reboot ;;
    "$hibernate") systemctl hibernate ;;
    "$lock") swaylock -f ;;
    "$suspend") systemctl suspend ;;
    "$logout") loginctl kill-user "$(whoami)" ;;
    *) exit 1 ;;
esac
