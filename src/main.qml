import Quickshell
import Quickshell.Wayland
import QtQuick
import "components"

ShellRoot {
    // Background Wallpaper
    Variants {
        model: Quickshell.screens
        PanelWindow {
            screen: modelData
            anchors.fill: parent
            WlrLayershell.layer: WlrLayer.Background
            
            Rectangle {
                anchors.fill: parent
                color: "#ca375c"
            }
        }
    }

    // Top Bar
    Variants {
        model: Quickshell.screens
        TopBar {
            modelData: modelData
        }
    }
}
