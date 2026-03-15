#!/bin/bash
# KWin pencere listesini qdbus ile alır, JSON döner

ACTIVE=$(qdbus org.kde.KWin /KWin org.kde.KWin.activeWindow 2>/dev/null | tr -d ' \n')
WINDOWS=$(qdbus org.kde.KWin /KWin org.kde.KWin.windows 2>/dev/null)

if [ -z "$WINDOWS" ]; then
    echo "[]"
    exit 0
fi

result="["
first=true

while IFS= read -r uuid; do
    [ -z "$uuid" ] && continue

    INFO=$(qdbus org.kde.KWin /KWin org.kde.KWin.getWindowInfo "$uuid" 2>/dev/null)
    [ -z "$INFO" ] && continue

    skip=$(echo "$INFO" | grep -i "^skipTaskbar:" | awk '{print $2}')
    [ "$skip" = "true" ] && continue

    title=$(echo "$INFO" | grep -i "^caption:" | sed 's/^[Cc]aption: //')
    appid=$(echo "$INFO" | grep -i "^resourceClass:" | awk '{print tolower($2)}')

    [ -z "$title" ] && continue

    # JSON escape
    title=$(echo "$title" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/\\t/g')

    activated=false
    [ "$uuid" = "$ACTIVE" ] && activated=true

    $first || result="${result},"
    result="${result}{\"title\":\"${title}\",\"appId\":\"${appid}\",\"activated\":${activated}}"
    first=false
done <<< "$WINDOWS"

result="${result}]"
echo "$result"
