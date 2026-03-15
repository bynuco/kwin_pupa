#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

sleep 2
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"
quickshell -p "$SCRIPT_DIR/src/main.qml" &
sleep 3
exec xterm
