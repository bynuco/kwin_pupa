#!/bin/bash
# kwin_watch.js tarafından kwinrc'ye yazılan pencere listesini okur

awk '/^\[Script-kwin_pupa_windows\]/{p=1;next} /^\[/{p=0} p && /^windowsJson=/{sub(/^windowsJson=/,""); print; exit}' \
    "$HOME/.config/kwinrc" 2>/dev/null || echo "[]"
