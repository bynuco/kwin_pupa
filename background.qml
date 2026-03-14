import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
    PanelWindow {
        id: background

        // Tüm ekranı kapla
        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        // Wayland layer ayarları
        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.exclusionZone: -1

        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: "#ff0000"
            opacity: 1.0
        }
    }
}