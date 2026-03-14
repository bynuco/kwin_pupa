#!/bin/bash

export QT_QPA_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

dbus-run-session kwin_wayland --xwayland --exit-with-session \
    "bash -c 'quickshell -p $SCRIPT_DIR/background/shell.qml & sleep 1 && xterm'"