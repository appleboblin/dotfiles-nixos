# variables
active='active'
screen='screen'
area='area'

chosen=$(printf "%s\n%s\n%s" "$screen" "$active" "$area" | rofi -dmenu -p "Screenshot" -theme-str 'window {width: 5.5em;} listview {lines: 3;}')

case $chosen in
    "$screen") grimblast --notify --cursor copysave screen ~/Pictures/Screenshots/screenshot_"$(date '+%Y%m%d_%H%M%S')".png ;;
    "$active") grimblast --notify --cursor copysave active ~/Pictures/Screenshots/screenshot_"$(date '+%Y%m%d_%H%M%S')".png ;;
    "$area") grimblast --notify --cursor copysave area ~/Pictures/Screenshots/screenshot_"$(date '+%Y%m%d_%H%M%S')".png ;;
    *) exit 1 ;;
esac
