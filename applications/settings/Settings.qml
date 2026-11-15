import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: settingsWindow
    title: "Revolt Settings"
    width: 920
    height: 620
    visible: true
    color: "#080B16"

    property string currentSection: "Appearance"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Sidebar
        Rectangle {
            Layout.fillHeight: true
            implicitWidth: 240
            color: "#0B0D14"
            border.color: "#191F31"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Text { text: "Settings"; color: "#F8FAFC"; font.bold: true; font.pixelSize: 20; Layout.leftMargin: 8 }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: [
                        { name: "Appearance", icon: "🎨" },
                        { name: "Wallpaper", icon: "🖼️" },
                        { name: "Revolt Island", icon: "💊" },
                        { name: "Revolt AI", icon: "🤖" },
                        { name: "Display", icon: "🖥️" },
                        { name: "Sound", icon: "🔊" },
                        { name: "Network & Wi-Fi", icon: "📶" },
                        { name: "Bluetooth", icon: "📡" },
                        { name: "Power & Battery", icon: "🔋" },
                        { name: "About RevoltOS", icon: "ℹ️" }
                    ]
                    delegate: Rectangle {
                        width: parent.width
                        height: 38
                        radius: 8
                        color: modelData.name === settingsWindow.currentSection ? "#1F1B3E" : (navArea.containsMouse ? "#111625" : "transparent")

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            spacing: 10
                            Text { text: modelData.icon; font.pixelSize: 14 }
                            Text {
                                text: modelData.name
                                color: modelData.name === settingsWindow.currentSection ? "#F8FAFC" : "#9299AA"
                                font.pixelSize: 13
                                font.weight: modelData.name === settingsWindow.currentSection ? Font.SemiBold : Font.Normal
                            }
                        }

                        MouseArea {
                            id: navArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: settingsWindow.currentSection = modelData.name
                        }
                    }
                }
            }
        }

        // Settings Detail
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#080B16"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 32
                spacing: 20

                Text { text: settingsWindow.currentSection; font.pixelSize: 24; font.bold: true; color: "#F8FAFC" }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#191F31"
                }

                // Dynamic options based on current section
                Rectangle {
                    Layout.fillWidth: true
                    height: 68
                    radius: 12
                    color: "#111625"
                    border.color: "#191F31"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        ColumnLayout {
                            Text { text: "Dark Mode"; color: "#F8FAFC"; font.bold: true; font.pixelSize: 14 }
                            Text { text: "Use Obsidian Navy & Violet accent theme"; color: "#9299AA"; font.pixelSize: 12 }
                        }
                        Item { Layout.fillWidth: true }
                        Switch { checked: true }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 68
                    radius: 12
                    color: "#111625"
                    border.color: "#191F31"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        ColumnLayout {
                            Text { text: "Revolt Island Top Center Pill"; color: "#F8FAFC"; font.bold: true; font.pixelSize: 14 }
                            Text { text: "Show real-time MPRIS media, hardware stats, and notifications"; color: "#9299AA"; font.pixelSize: 12 }
                        }
                        Item { Layout.fillWidth: true }
                        Switch { checked: true }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 68
                    radius: 12
                    color: "#111625"
                    border.color: "#191F31"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        ColumnLayout {
                            Text { text: "Local AI Integration (Ollama / revoltd)"; color: "#F8FAFC"; font.bold: true; font.pixelSize: 14 }
                            Text { text: "Listen on 127.0.0.1:18070 for instant offline terminal assistance"; color: "#9299AA"; font.pixelSize: 12 }
                        }
                        Item { Layout.fillWidth: true }
                        Switch { checked: true }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}
