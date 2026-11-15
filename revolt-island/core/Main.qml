import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: islandWindow
    title: "Revolt Island"
    visible: true
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | (currentState === "ai" ? Qt.Window : Qt.WindowDoesNotAcceptFocus)

    // Dynamic Geometry Transition
    property string currentState: "idle" // idle, media, system, ai
    property int targetWidth: currentState === "ai" ? 640 : (currentState === "compact" ? 360 : 760)
    property int targetHeight: currentState === "ai" ? 520 : 42
    property int targetRadius: currentState === "ai" ? 20 : 21

    // Hardware Telemetry Properties
    property int cpuUsage: 12
    property int ramUsage: 42
    property int gpuUsage: 8
    property string currentTrack: "Imagine Dragons - Believer"
    property bool isPlaying: true
    property string currentTimeString: "21:45 | Sat, Apr 26"

    width: targetWidth
    height: targetHeight
    color: "transparent"

    // Top-Center Anchoring
    x: (Screen.width - width) / 2
    y: 10

    Behavior on width {
        NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
    }
    Behavior on height {
        NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var date = new Date()
            var hours = ("0" + date.getHours()).slice(-2)
            var mins = ("0" + date.getMinutes()).slice(-2)
            var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            currentTimeString = hours + ":" + mins + " | " + days[date.getDay()] + ", " + months[date.getMonth()] + " " + date.getDate()
        }
    }

    // Main Floating Capsule Surface
    Rectangle {
        id: pillSurface
        anchors.fill: parent
        radius: targetRadius
        color: "#080B16"
        border.color: islandWindow.currentState === "ai" ? "#8B5CF6" : "#281D4C"
        border.width: 1.5
        clip: true

        // Ambient inner glow
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.color: "#8B5CF6"
            border.width: 1
            opacity: 0.35
        }

        // ==================== 1. IDLE / RESTING STATE (3-PILL ISLAND) ====================
        Item {
            id: idleView
            anchors.fill: parent
            visible: islandWindow.currentState === "idle"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 14

                // Section A: Media Pill
                Rectangle {
                    Layout.fillHeight: true
                    implicitWidth: 260
                    radius: 16
                    color: "#111625"
                    border.color: "#191F31"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 8

                        Text { text: "🎵"; font.pixelSize: 12 }
                        Text {
                            text: "Playing: " + islandWindow.currentTrack
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.Medium
                            color: "#F8FAFC"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        Text { text: "⏮️"; font.pixelSize: 10; color: "#A78BFA" }
                        Text { text: islandWindow.isPlaying ? "⏸️" : "▶️"; font.pixelSize: 10; color: "#A78BFA" }
                        Text { text: "⏭️"; font.pixelSize: 10; color: "#A78BFA" }
                    }
                }

                // Section B: Hardware Telemetry Pills
                RowLayout {
                    spacing: 6

                    // CPU Pill
                    Rectangle {
                        height: 28
                        width: 72
                        radius: 14
                        color: "#111625"
                        border.color: "#191F31"
                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 4
                            Text { text: "⚡"; font.pixelSize: 10 }
                            Text { text: "CPU " + islandWindow.cpuUsage + "%"; color: "#8B5CF6"; font.pixelSize: 10; font.bold: true }
                        }
                    }

                    // RAM Pill
                    Rectangle {
                        height: 28
                        width: 76
                        radius: 14
                        color: "#111625"
                        border.color: "#191F31"
                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 4
                            Text { text: "💾"; font.pixelSize: 10 }
                            Text { text: "RAM " + islandWindow.ramUsage + "%"; color: "#A78BFA"; font.pixelSize: 10; font.bold: true }
                        }
                    }

                    // GPU Pill
                    Rectangle {
                        height: 28
                        width: 72
                        radius: 14
                        color: "#111625"
                        border.color: "#191F31"
                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 4
                            Text { text: "🎮"; font.pixelSize: 10 }
                            Text { text: "GPU " + islandWindow.gpuUsage + "%"; color: "#C4B5FD"; font.pixelSize: 10; font.bold: true }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // Section C: Clock Pill
                Rectangle {
                    Layout.fillHeight: true
                    implicitWidth: 140
                    radius: 16
                    color: "#111625"
                    border.color: "#191F31"
                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6
                        Text {
                            text: islandWindow.currentTimeString
                            color: "#F8FAFC"
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.SemiBold
                        }
                    }
                }

                // AI Trigger Button
                Rectangle {
                    width: 28
                    height: 28
                    radius: 14
                    color: "#8B5CF6"
                    Text { anchors.centerIn: parent; text: "🤖"; font.pixelSize: 12 }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: islandWindow.currentState = "ai"
                    }
                }
            }
        }

        // ==================== 2. REVOLT AI ASSISTANT CARD STATE ====================
        ColumnLayout {
            id: aiView
            anchors.fill: parent
            anchors.margins: 20
            visible: islandWindow.currentState === "ai"
            spacing: 14

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "/usr/share/revoltos/branding/logo/variants/revoltos-symbol-r.svg"
                    sourceSize.width: 28
                    sourceSize.height: 28
                }

                Text {
                    text: "Revolt AI"
                    color: "#F8FAFC"
                    font.family: "Inter"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                }

                Rectangle {
                    width: 68
                    height: 22
                    radius: 11
                    color: "#1E1538"
                    border.color: "#10B981"
                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 4
                        Rectangle { width: 6; height: 6; radius: 3; color: "#10B981" }
                        Text { text: "Online"; color: "#10B981"; font.pixelSize: 10; font.bold: true }
                    }
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "✕"
                    flat: true
                    contentItem: Text { text: "✕"; color: "#9299AA"; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter }
                    onClicked: islandWindow.currentState = "idle"
                }
            }

            // Body Card
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 14
                color: "#111625"
                border.color: "#191F31"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 12

                    Text {
                        text: "Hello! 👋\nHow can I help you today?"
                        font.family: "Inter"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        color: "#F8FAFC"
                    }

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        TextArea {
                            id: aiOutputText
                            readOnly: true
                            wrapMode: TextEdit.Wrap
                            color: "#E2E8F0"
                            font.family: "Inter"
                            font.pixelSize: 13
                            text: "I am Revolt AI, your local & cloud system intelligence assistant.\nReady for code generation, terminal diagnosis, or deep web research."
                            background: null
                        }
                    }

                    // Action Chips
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Repeater {
                            model: [
                                { label: "🔍 Search the web", prompt: "Search web for: " },
                                { label: "💡 Explain this", prompt: "Explain this: " },
                                { label: "✍️ Write something", prompt: "Draft: " },
                                { label: "💻 Help with code", prompt: "Code: " }
                            ]

                            Button {
                                text: modelData.label
                                contentItem: Text { text: parent.text; color: "#C4B5FD"; font.pixelSize: 11; font.weight: Font.Medium; horizontalAlignment: Text.AlignHCenter }
                                background: Rectangle { radius: 8; color: "#191F31"; border.color: "#281D4C" }
                                onClicked: aiInputField.text = modelData.prompt
                            }
                        }
                    }
                }
            }

            // Input Bar
            Rectangle {
                Layout.fillWidth: true
                height: 48
                radius: 12
                color: "#111625"
                border.color: "#8B5CF6"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 12

                    TextInput {
                        id: aiInputField
                        Layout.fillWidth: true
                        color: "#F8FAFC"
                        font.pixelSize: 14
                        clip: true
                        property string placeholderText: "Ask anything..."
                        Text {
                            text: aiInputField.placeholderText
                            color: "#9299AA"
                            font.pixelSize: 14
                            visible: !aiInputField.text && !aiInputField.activeFocus
                        }
                        onAccepted: sendActionBtn.clicked()
                    }

                    Button {
                        id: sendActionBtn
                        width: 32
                        height: 32
                        background: Rectangle { radius: 8; color: "#8B5CF6" }
                        contentItem: Text { text: "➤"; color: "#FFF"; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                        onClicked: {
                            if (aiInputField.text.trim()) {
                                aiOutputText.text += "\n\n> " + aiInputField.text + "\n\n[Revolt AI Thinking...]\n"
                                aiInputField.text = ""
                            }
                        }
                    }
                }
            }
        }
    }
}
