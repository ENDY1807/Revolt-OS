import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: storeWindow
    title: "Revolt Store"
    width: 980
    height: 660
    visible: true
    color: "#080B16"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Categories Sidebar
        Rectangle {
            Layout.fillHeight: true
            implicitWidth: 260
            color: "#0B0D14"
            border.color: "#191F31"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 16

                RowLayout {
                    spacing: 10
                    Image {
                        source: "/usr/share/revoltos/branding/logo/variants/revoltos-symbol-r.svg"
                        sourceSize.width: 28
                        sourceSize.height: 28
                    }
                    Text { text: "Revolt Store"; color: "#F8FAFC"; font.bold: true; font.pixelSize: 18 }
                }

                // Search Box
                Rectangle {
                    Layout.fillWidth: true
                    height: 38
                    radius: 8
                    color: "#111625"
                    border.color: "#191F31"
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        Text { text: "🔍"; color: "#9299AA"; font.pixelSize: 12 }
                        TextInput {
                            id: searchInput
                            Layout.fillWidth: true
                            color: "#F8FAFC"
                            font.pixelSize: 13
                            clip: true
                        }
                    }
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: [
                        { name: "All Apps", count: "250", icon: "📦" },
                        { name: "Development", count: "48", icon: "💻" },
                        { name: "Games", count: "72", icon: "🎮" },
                        { name: "Multimedia", count: "36", icon: "🎬" },
                        { name: "Internet", count: "41", icon: "🌐" },
                        { name: "Office", count: "29", icon: "📄" },
                        { name: "Settings & System", count: "18", icon: "⚙️" }
                    ]
                    delegate: Rectangle {
                        width: parent.width
                        height: 40
                        radius: 8
                        color: index === 0 ? "#1F1B3E" : (mouseItem.containsMouse ? "#111625" : "transparent")

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            Text { text: modelData.icon; font.pixelSize: 14 }
                            Text { text: modelData.name; color: index === 0 ? "#F8FAFC" : "#9299AA"; font.pixelSize: 13; font.weight: index === 0 ? Font.SemiBold : Font.Normal }
                            Item { Layout.fillWidth: true }
                            Text { text: modelData.count; color: "#8B5CF6"; font.pixelSize: 11; font.bold: true }
                        }

                        MouseArea {
                            id: mouseItem
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }
                }
            }
        }

        // Store Content Grid
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#080B16"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 32
                spacing: 24

                // Featured Hero Banner
                Rectangle {
                    Layout.fillWidth: true
                    height: 140
                    radius: 16
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#2E1065" }
                        GradientStop { position: 1.0; color: "#0B0D14" }
                    }
                    border.color: "#8B5CF6"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 28
                        ColumnLayout {
                            spacing: 4
                            Text { text: "Discover Amazing Apps"; font.pixelSize: 22; font.bold: true; color: "#F8FAFC" }
                            Text { text: "Explore verified developer tools, native Linux apps, and games."; font.pixelSize: 13; color: "#C4B5FD" }
                        }
                        Item { Layout.fillWidth: true }
                        Text { text: "🛍️"; font.pixelSize: 52 }
                    }
                }

                Text { text: "Popular Developer & Creator Apps"; font.pixelSize: 16; font.bold: true; color: "#F8FAFC" }

                // App Cards Grid
                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    rowSpacing: 16
                    columnSpacing: 16

                    Repeater {
                        model: [
                            { name: "Visual Studio Code", cat: "Development", desc: "Code editor redefined.", icon: "📝" },
                            { name: "Docker & Podman", cat: "Development", desc: "Containerized environments.", icon: "🐳" },
                            { name: "Steam + Proton", cat: "Gaming", desc: "Play 10,000+ PC games.", icon: "🎮" },
                            { name: "Ollama Local AI", cat: "AI & ML", desc: "Run LLMs entirely offline.", icon: "🦙" },
                            { name: "OBS Studio", cat: "Multimedia", desc: "Live streaming & recording.", icon: "📹" },
                            { name: "Discord", cat: "Internet", desc: "All-in-one voice & text.", icon: "💬" }
                        ]

                        Rectangle {
                            Layout.fillWidth: true
                            height: 110
                            radius: 12
                            color: "#111625"
                            border.color: cardArea.containsMouse ? "#8B5CF6" : "#191F31"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 14
                                Text { text: modelData.icon; font.pixelSize: 32 }
                                ColumnLayout {
                                    spacing: 2
                                    Text { text: modelData.name; font.pixelSize: 14; font.bold: true; color: "#F8FAFC" }
                                    Text { text: modelData.cat; font.pixelSize: 11; color: "#8B5CF6" }
                                    Text { text: modelData.desc; font.pixelSize: 11; color: "#9299AA" }
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: "Install"
                                    background: Rectangle { radius: 8; color: "#8B5CF6" }
                                    contentItem: Text { text: parent.text; color: "#FFF"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                                }
                            }

                            MouseArea {
                                id: cardArea
                                anchors.fill: parent
                                hoverEnabled: true
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}
