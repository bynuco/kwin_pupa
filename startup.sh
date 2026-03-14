#!/bin/bash

export QT_QPA_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

dbus-run-session kwin_wayland --xwayland --exit-with-session bash -c "
    sleep 2
    quickshell -p '$SCRIPT_DIR/background/shell.qml' &
    quickshell -p '$SCRIPT_DIR/topbar/shell.qml' &
    sleep 3
    exec xterm
"