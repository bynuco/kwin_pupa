import Quickshell
import Quickshell.Wayland
import QtQuick
import "components"

ShellRoot {
    // Background Wallpaper
    Variants {
        variants: Quickshell.screens
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
        variants: Quickshell.screens
        TopBar {
            screen: modelData
        }
    }
}
