#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

sleep 2
quickshell -p "$SCRIPT_DIR/src/main.qml" &
sleep 3
exec xterm