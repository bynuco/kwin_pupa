#!/bin/bash

export QT_QPA_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

chmod +x "$SCRIPT_DIR/session.sh"

# KWin script çıktısı bu dosyaya gider; bottom bar pencere listesi buradan okunur
export KWIN_PUPA_STDOUT_LOG="/tmp/kwin_pupa_stdout.log"
exec dbus-run-session kwin_wayland --xwayland --exit-with-session "$SCRIPT_DIR/session.sh" 2>&1 | tee "$KWIN_PUPA_STDOUT_LOG"