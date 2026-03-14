import Quickshell
import Quickshell.Wayland
import QtQuick
import "components"

ShellRoot {
    // Background Wallpaper
    Variants {
        model: Quickshell.screens
        delegate: Component {
            PanelWindow {
                property var modelData
                screen: modelData
                anchors: Quickshell.Top | Quickshell.Bottom | Quickshell.Left | Quickshell.Right
                WlrLayershell.layer: WlrLayer.Background
                
                Rectangle {
                    anchors.fill: parent
                    color: "#ca375c"
                }
            }
        }
    }

    // Top Bar
    Variants {
        model: Quickshell.screens
        delegate: Component {
            TopBar {
                property var modelData
                // modelData mapping is handled automatically by Variants inside the delegate
                // but we explicitly pass it if needed by the component
                modelData: modelData
            }
        }
    }
}
