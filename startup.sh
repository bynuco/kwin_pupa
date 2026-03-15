#!/bin/bash

export QT_QPA_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland
# Wayland eklentisi yüklenemezse hata ayıklama için (isteğe bağlı: WAYLAND_DEBUG=1)
# export QT_DEBUG_PLUGINS=1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

chmod +x "$SCRIPT_DIR/session.sh"
chmod +x "$SCRIPT_DIR/scripts/get_windows.sh"
chmod +x "$SCRIPT_DIR/scripts/activate_window.sh"

exec dbus-run-session kwin_wayland --xwayland --xkb-layout tr --exit-with-session "$SCRIPT_DIR/session.sh"