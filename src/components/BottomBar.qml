import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: bottombar
    property var modelData
    screen: modelData !== undefined ? modelData : null

    anchors {
        bottom: true
        left: true
        right: true
    }

    // Top layer = pencerelerin üstünde çizilir (konum hâlâ altta)
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: implicitHeight

    implicitHeight: 40

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0.1, 0.1, 0.1, 0.85)

        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 1
            color: "#1affff"
            opacity: 0.3
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 8

        // Sol: Başlat ikonu
        Rectangle {
            id: startButton
            width: 36
            height: 36
            color: "transparent"
            Layout.alignment: Qt.AlignVCenter

            IconImage {
                anchors.centerIn: parent
                source: "file://" + Quickshell.shellPath("../assets/icons/menu.svg")
                width: 24
                height: 24
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: startButton.opacity = 0.7
                onExited: startButton.opacity = 1.0
                onClicked: Quickshell.execDetached(["xterm"])
            }
        }

        Item { Layout.fillWidth: true }
    }
}
