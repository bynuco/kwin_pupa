#!/bin/bash

export QT_QPA_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland

dbus-run-session kwin_wayland --xwayland --exit-with-session "bash -c xterm & quickshell -p shell.qml"