#!/bin/bash
# Pencere listesini wmctrl (XWayland) ile alır, JSON döner

WINDOWS=$(wmctrl -l -x 2>/dev/null)

if [ -z "$WINDOWS" ]; then
    echo "[]"
    exit 0
fi

# Aktif pencere ID'si
ACTIVE_HEX=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | grep -o '0x[0-9a-f]*' | head -1)

result="["
first=true

while IFS= read -r line; do
    [ -z "$line" ] && continue

    id=$(echo "$line" | awk '{print $1}')
    desktop=$(echo "$line" | awk '{print $2}')
    wm_class=$(echo "$line" | awk '{print $4}')
    title=$(echo "$line" | awk '{for(i=5;i<=NF;i++) printf "%s%s",$i,(i<NF?" ":""); print ""}')

    # Masaüstü ve başlıksız pencereleri atla
    [ "$desktop" = "-1" ] && continue
    [ -z "$title" ] && continue

    appid=$(echo "$wm_class" | awk -F'.' '{print tolower($NF)}')

    # JSON escape
    title=$(echo "$title" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/ /g')

    activated=false
    [ "$id" = "$ACTIVE_HEX" ] && activated=true

    $first || result="${result},"
    result="${result}{\"title\":\"${title}\",\"appId\":\"${appid}\",\"activated\":${activated},\"uuid\":\"${id}\"}"
    first=false
done <<< "$WINDOWS"

result="${result}]"
echo "$result"
