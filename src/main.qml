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
                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }
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
                modelData: modelData
            }
        }
    }

    // Bottom Bar (başlat ikonu solda)
    Variants {
        model: Quickshell.screens
        delegate: Component {
            BottomBar {
                property var modelData
                modelData: modelData
            }
        }
    }
}
