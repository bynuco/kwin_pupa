import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
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

    // KWin: Python ile pencere listesi (ToplevelManager KWin'de boş)
    property var kwinWindowList: []
    property string projectRoot: Quickshell.shellPath("..")

    Process {
        id: winListProcess
        workingDirectory: projectRoot
        command: ["python3", "scripts/get_windows.py"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var t = this.text.trim()
                    if (t) {
                        var arr = JSON.parse(t)
                        bottombar.kwinWindowList = Array.isArray(arr) ? arr : []
                    }
                } catch (_) {
                    bottombar.kwinWindowList = []
                }
                winListProcess.running = false
            }
        }
    }
    Timer {
        interval: 2500
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            if (!winListProcess.running)
                winListProcess.running = true
        }
    }

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

        // Başlat ikonu (sadece ikon, terminal açmaz)
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
                onClicked: { /* başlat menüsü — terminal burada açılmaz */ }
            }
        }

        // Terminal butonu — sadece buna tıklanınca xterm açılır
        Rectangle {
            id: terminalButton
            width: 38
            height: 34
            radius: 6
            color: Qt.rgba(0.25, 0.25, 0.3, 0.9)
            Layout.alignment: Qt.AlignVCenter

            border.width: 1
            border.color: Qt.rgba(0.4, 0.4, 0.5, 0.6)

            IconImage {
                anchors.centerIn: parent
                source: "file://" + Quickshell.shellPath("../assets/icons/terminal.svg")
                width: 20
                height: 20
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    terminalButton.color = Qt.rgba(0.35, 0.35, 0.4, 0.95)
                }
                onExited: {
                    terminalButton.color = Qt.rgba(0.25, 0.25, 0.3, 0.9)
                }
                onClicked: Quickshell.execDetached(["xterm"])
            }
        }

        // Açık pencereler — KWin: kwinWindowList; wlroots: ToplevelManager
        Repeater {
            model: kwinWindowList.length > 0 ? kwinWindowList : (ToplevelManager.toplevels || [])
            delegate: Rectangle {
                width: Math.min(winTitle.implicitWidth + 24, 180)
                height: 32
                radius: 4
                Layout.alignment: Qt.AlignVCenter
                color: (typeof modelData.activated !== "undefined" && modelData.activated) ? Qt.rgba(0.35, 0.35, 0.45, 0.95) : Qt.rgba(0.22, 0.22, 0.28, 0.9)
                border.width: 1
                border.color: (typeof modelData.activated !== "undefined" && modelData.activated) ? "#1affff" : Qt.rgba(0.4, 0.4, 0.5, 0.4)

                Text {
                    id: winTitle
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    verticalAlignment: Text.AlignVCenter
                    text: modelData.title || modelData.appId || "Pencere"
                    color: "white"
                    font.pixelSize: 13
                    font.family: "Inter, Roboto, sans-serif"
                    elide: Text.ElideRight
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (typeof modelData.activate === "function")
                            modelData.activate()
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }
    }
}
