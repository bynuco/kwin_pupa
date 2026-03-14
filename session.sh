#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

sleep 2
quickshell -p "$SCRIPT_DIR/background/shell.qml" &
quickshell -p "$SCRIPT_DIR/topbar/shell.qml" &
sleep 3
exec xterm