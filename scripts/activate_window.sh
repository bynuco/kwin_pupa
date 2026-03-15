#!/bin/bash
# Verilen UUID'ye sahip pencereyi aktifleştirir (one-shot KWin script)

UUID="$1"
[ -z "$UUID" ] && exit 1

TMPJS=$(mktemp /tmp/kwin_act_XXXXXX.js)
cat > "$TMPJS" << JSEOF
var wins = workspace.stackingOrder;
var target = "$UUID";
for (var i = 0; i < wins.length; i++) {
    if (String(wins[i].internalId) === target) {
        workspace.activeWindow = wins[i];
        break;
    }
}
JSEOF

ID=$(dbus-send --session --print-reply --dest=org.kde.KWin \
    /Scripting org.kde.kwin.Scripting.loadScript \
    "string:$TMPJS" "string:kwin_pupa_act_$$" 2>/dev/null \
    | awk '/int32/{print $2; exit}')

[ -n "$ID" ] && dbus-send --session --dest=org.kde.KWin \
    "/Scripting/Script${ID}" org.kde.kwin.Script.run 2>/dev/null

rm -f "$TMPJS"
