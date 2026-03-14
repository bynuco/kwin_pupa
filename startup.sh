#!/bin/bash

export QT_QPA_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

chmod +x "$SCRIPT_DIR/session.sh"

dbus-run-session kwin_wayland --xwayland --exit-with-session "$SCRIPT_DIR/session.sh"