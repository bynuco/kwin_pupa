#!/bin/bash
# KWin pencere listesini DBus (Wayland-native) ile alır, JSON döner
# Gereksinim: dbus-send (dbus paketi, genellikle kurulu gelir)

ACTIVE=$(dbus-send --session --print-reply --dest=org.kde.KWin \
    /KWin org.kde.KWin.activeWindow 2>/dev/null \
    | grep 'string' | grep -o '"[^"]*"' | tr -d '"')

WINDOWS_RAW=$(dbus-send --session --print-reply --dest=org.kde.KWin \
    /KWin org.kde.KWin.windows 2>/dev/null)

WINDOWS=$(echo "$WINDOWS_RAW" | grep 'string' | grep -o '"[^"]*"' | tr -d '"')

if [ -z "$WINDOWS" ]; then
    echo "[]"
    exit 0
fi

result="["
first=true

while IFS= read -r uuid; do
    [ -z "$uuid" ] && continue

    INFO_RAW=$(dbus-send --session --print-reply --dest=org.kde.KWin \
        /KWin org.kde.KWin.getWindowInfo "string:$uuid" 2>/dev/null)
    [ -z "$INFO_RAW" ] && continue

    skip=$(echo "$INFO_RAW" | grep -A1 '"skipTaskbar"' | grep 'boolean' | awk '{print $2}')
    [ "$skip" = "true" ] && continue

    title=$(echo "$INFO_RAW" | grep -A1 '"caption"' | grep 'string' | grep -o '"[^"]*"' | tr -d '"')
    appid=$(echo "$INFO_RAW" | grep -A1 '"resourceClass"' | grep 'string' | grep -o '"[^"]*"' | tr -d '"' | tr '[:upper:]' '[:lower:]')

    [ -z "$title" ] && continue

    title=$(echo "$title" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/ /g')
    uuid_esc=$(echo "$uuid" | sed 's/\\/\\\\/g; s/"/\\"/g')

    activated=false
    [ "$uuid" = "$ACTIVE" ] && activated=true

    $first || result="${result},"
    result="${result}{\"title\":\"${title}\",\"appId\":\"${appid}\",\"activated\":${activated},\"uuid\":\"${uuid_esc}\"}"
    first=false
done <<< "$WINDOWS"

result="${result}]"
echo "$result"
