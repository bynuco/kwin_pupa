#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

sleep 2
quickshell -p "$SCRIPT_DIR/src/main.qml" &