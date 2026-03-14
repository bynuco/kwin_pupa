import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

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
                }

                implicitHeight: 32
                color: "#1e1e2e"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Text {
                        text: "GoodOS"
                        color: "#cdd6f4"
                        font.pixelSize: 13
                        font.bold: true
                        font.family: "sans-serif"
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        id: timeText
                        text: "..."
                        color: "#cdd6f4"
                        font.pixelSize: 13
                        font.family: "sans-serif"

                        // Process burada — timeText ile aynı scope'ta
                        Process {
                            id: dateProc
                            command: ["date", "+%H:%M  %a %d %b"]
                            running: true
                            stdout: SplitParser {
                                onRead: data => timeText.text = data
                            }
                        }

                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: dateProc.running = true
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        id: hostText
                        color: "#a6adc8"
                        font.pixelSize: 12
                        font.family: "sans-serif"
                        text: ""

                        Process {
                            command: ["hostname"]
                            running: true
                            stdout: SplitParser {
                                onRead: data => hostText.text = data
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: "#313244"
                }
            }
        }
    }
}