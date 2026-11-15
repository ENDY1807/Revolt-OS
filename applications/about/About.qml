import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: aboutWindow
    title: "About RevoltOS"
    width: 480
    height: 560
    visible: true
    color: "#080B16"
    flags: Qt.Dialog

    Rectangle {
        anchors.fill: parent
        anchors.margins: 20
        radius: 18
        color: "#111625"
        border.color: "#8B5CF6"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 28
            spacing: 16

            RowLayout {
                spacing: 14
                Image {
                    source: "/usr/share/revoltos/branding/logo/variants/revoltos-symbol-r.svg"
                    sourceSize.width: 48
                    sourceSize.height: 48
                }
                ColumnLayout {
                    spacing: 2
                    Text {
                        text: "RevoltOS"
                        font.family: "Inter"
                        font.pixelSize: 22
                        font.weight: Font.Bold
                        color: "#F8FAFC"
                    }
                    Text {
                        text: "Beyond Limits."
                        font.family: "Inter"
                        font.pixelSize: 13
                        color: "#A78BFA"
                    }
                }
            }

            Rectangle { height: 1; Layout.fillWidth: true; color: "#191F31" }

            ColumnLayout {
                spacing: 6
                Text { text: "Version 1.0.0 BETA"; color: "#F8FAFC"; font.weight: Font.SemiBold; font.pixelSize: 14 }
                Text { text: "Built on Debian Linux (sid / rolling)"; color: "#9299AA"; font.pixelSize: 13 }
                Text { text: "Wayland Compositor (Hyprland 0.45+)"; color: "#9299AA"; font.pixelSize: 13 }
            }

            Text {
                text: "A next-gen developer Linux distribution with local AI, cutting-edge beauty, and high-performance kernel tuning."
                color: "#CBD5E1"
                font.family: "Inter"
                font.pixelSize: 13
                lineHeight: 1.4
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Rectangle { height: 1; Layout.fillWidth: true; color: "#191F31" }

            ColumnLayout {
                spacing: 8
                Text { text: "🌐  Website: https://revoltos.org"; color: "#8B5CF6"; font.pixelSize: 13 }
                Text { text: "📖  Documentation: https://docs.revoltos.org"; color: "#8B5CF6"; font.pixelSize: 13 }
                Text { text: "💬  Community: https://github.com/ENDY1807/Revolt-OS"; color: "#8B5CF6"; font.pixelSize: 13 }
            }

            Item { Layout.fillHeight: true }

            Button {
                Layout.fillWidth: true
                text: "⚡ Check for Updates"
                contentItem: Text {
                    text: parent.text
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.bold: true
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    implicitHeight: 40
                    radius: 10
                    color: parent.hovered ? "#7C3AED" : "#8B5CF6"
                }
                onClicked: {
                    console.log("[RevoltOS] Checking repository for rolling updates...")
                }
            }
        }
    }
}
