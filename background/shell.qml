import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Component {
            PanelWindow {
                property var modelData
                screen: modelData

                anchors {
                    top: true
                    left: true
                    right: true
                    bottom: true
                }

                color: "transparent"

                Component.onCompleted: {
                    if (this.WlrLayershell != null) {
                        this.WlrLayershell.layer = WlrLayer.Background
                        this.WlrLayershell.exclusionZone = -1
                        this.WlrLayershell.keyboardFocus = WlrKeyboardFocus.None
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: "#ca375c"
                }
            }
        }
    }
}