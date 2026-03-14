import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: topbar
    property var modelData
    screen: modelData

    height: 40
    anchors {
        top: true
        left: true
        right: true
    }

    color: "transparent"

    Component.onCompleted: {
        if (this.WlrLayershell != null) {
            this.WlrLayershell.layer = WlrLayer.Top
            this.WlrLayershell.exclusionZone = height
            this.WlrLayershell.keyboardFocus = WlrKeyboardFocus.None
        }
    }

    // Glassmorphism Background
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0.1, 0.1, 0.1, 0.85) // Dark charcoal with 85% opacity
        
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: "#1affff" // Neon cyan accent border
            opacity: 0.3
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 10

        // Left Section: Menu Icon
        Rectangle {
            width: 30
            height: 30
            color: "transparent"
            Layout.alignment: Qt.AlignVCenter
            
            Text {
                anchors.centerIn: parent
                text: "󰍜" // Material icon or similar
                color: "white"
                font.pixelSize: 20
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.opacity = 0.7
                onExited: parent.opacity = 1.0
            }
        }

        Item { Layout.fillWidth: true } // Spacer

        // Center Section: Clock
        Text {
            id: clockText
            Layout.alignment: Qt.AlignVCenter
            color: "white"
            font.pixelSize: 18
            font.weight: Font.DemiBold
            font.family: "Inter, Roboto, sans-serif"
            
            Timer {
                interval: 1000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    var date = new Date();
                    clockText.text = Qt.formatTime(date, "HH:mm");
                }
            }
        }

        Item { Layout.fillWidth: true } // Spacer

        // Right Section: Status Icons
        Row {
            spacing: 12
            Layout.alignment: Qt.AlignVCenter

            // Battery (If service available)
            Row {
                spacing: 5
                visible: UPower.displayDevice != null
                Text {
                    text: UPower.displayDevice.iconName.includes("charging") ? "󰂄" : "󰁹"
                    color: "#1affff"
                    font.pixelSize: 16
                }
                Text {
                    text: Math.round(UPower.displayDevice.percentage) + "%"
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Inter, Roboto, sans-serif"
                }
            }

            // Connection (Placeholder)
            Text {
                text: "󰖩"
                color: "white"
                font.pixelSize: 16
            }
        }
    }
}
