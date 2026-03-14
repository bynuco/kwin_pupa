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
                WlrLayershell.layer: WlrLayer.Background
                WlrLayershell.anchor: WlrLayerAnchor.Top | WlrLayerAnchor.Bottom | WlrLayerAnchor.Left | WlrLayerAnchor.Right
                
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
