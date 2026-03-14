// shell.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

ShellRoot {
    // Singleton: saat verisi tüm ekranlar tarafından paylaşılır
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

    // Her ekran için bir bar
    Variants {
        model: Quickshell.screens
        delegate: Component {
            PanelWindow {
                required property var modelData
                screen: modelData

                anchors {
                    top: true
                    left: true
                    right: true
                }

                height: 32
                color: "#1e1e2e"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    // Sol: logo
                    Text {
                        text: "GoodOS"
                        color: "#cdd6f4"
                        font.pixelSize: 13
                        font.bold: true
                    }

                    // Orta: boşluk
                    Item { Layout.fillWidth: true }

                    // Saat + tarih
                    Text {
                        id: timeText
                        text: "..."
                        color: "#cdd6f4"
                        font.pixelSize: 13
                    }

                    // Orta: boşluk
                    Item { Layout.fillWidth: true }

                    // Sağ: hostname
                    Text {
                        id: hostText
                        color: "#a6adc8"
                        font.pixelSize: 12

                        Process {
                            command: ["hostname"]
                            running: true
                            stdout: SplitParser {
                                onRead: data => hostText.text = data
                            }
                        }
                    }
                }

                // Alt ayırıcı çizgi
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