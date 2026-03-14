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

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    implicitHeight: 40
    anchors: Quickshell.Top | Quickshell.Left | Quickshell.Right

    color: "transparent"

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
            
            IconImage {
                anchors.centerIn: parent
                source: "../../assets/icons/menu.svg"
                width: 20
                height: 20
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
            
            leftPadding: 24

            IconImage {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                source: "../../assets/icons/clock.svg"
                width: 16
                height: 16
            }
            
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
                IconImage {
                    source: UPower.displayDevice.iconName.includes("charging") ? "../../assets/icons/battery-charging.svg" : "../../assets/icons/battery.svg"
                    width: 18
                    height: 18
                    Layout.alignment: Qt.AlignVCenter
                }
                Text {
                    text: Math.round(UPower.displayDevice.percentage) + "%"
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Inter, Roboto, sans-serif"
                }
            }

            // Connection (Placeholder)
            IconImage {
                source: "../../assets/icons/wifi.svg"
                width: 18
                height: 18
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }
}
