#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

sleep 2
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"

# KWin pencere takip scriptini yükle
dbus-send --session --dest=org.kde.KWin /Scripting \
    org.kde.kwin.Scripting.loadScript \
    "string:$SCRIPT_DIR/scripts/kwin_watch.js" \
    "string:kwin_pupa_windows" 2>/dev/null

quickshell -p "$SCRIPT_DIR/src/main.qml" &

exec xterm
