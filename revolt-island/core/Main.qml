import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: islandWindow
    title: "Revolt Island"
    visible: true
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.WindowDoesNotAcceptFocus

    // Dynamic Geometry Transition
    property string currentState: "idle" // idle, media, system, ai
    property int targetWidth: currentState === "ai" ? 680 : (currentState === "media" ? 380 : (currentState === "system" ? 340 : 180))
    property int targetHeight: currentState === "ai" ? 520 : (currentState === "media" ? 44 : (currentState === "system" ? 44 : 36))
    property int targetRadius: currentState === "ai" ? 24 : 18

    width: targetWidth
    height: targetHeight
    color: "transparent"

    // Top-Center Anchoring
    x: (Screen.width - width) / 2
    y: 8

    Behavior on width {
        NumberAnimation { duration: 320; easing.type: Easing.OutCubic }
    }
    Behavior on height {
        NumberAnimation { duration: 320; easing.type: Easing.OutCubic }
    }

    // Main Floating Pill Surface
    Rectangle {
        id: pillSurface
        anchors.fill: parent
        radius: targetRadius
        color: "#15152B"
        border.color: islandWindow.currentState === "ai" ? "#8B35FF" : "#303050"
        border.width: islandWindow.currentState === "ai" ? 2 : 1
        clip: true

        Behavior on border.color {
            ColorAnimation { duration: 250 }
        }

        // ==================== 1. IDLE STATE ====================
        Item {
            id: idleView
            anchors.fill: parent
            visible: islandWindow.currentState === "idle"

            RowLayout {
                anchors.centerIn: parent
                spacing: 8

                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: "#B56BFF"
                }

                Text {
                    text: "RevoltOS"
                    color: "#F5F3FF"
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                }

                Text {
                    text: "•"
                    color: "#9290AA"
                    font.pixelSize: 10
                }

                Text {
                    text: "AI Ready"
                    color: "#9290AA"
                    font.pixelSize: 11
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    islandWindow.currentState = "ai"
                    islandWindow.flags = Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
                }
            }
        }

        // ==================== 2. AI INTERACTION STATE ====================
        ColumnLayout {
            id: aiView
            anchors.fill: parent
            anchors.margins: 16
            visible: islandWindow.currentState === "ai"
            spacing: 12

            // Header Bar
            RowLayout {
                Layout.fillWidth: true

                Rectangle {
                    width: 24
                    height: 24
                    radius: 6
                    color: "#8B35FF"
                    Text {
                        anchors.centerIn: parent
                        text: "󰚩"
                        color: "#FFFFFF"
                        font.pixelSize: 13
                    }
                }

                Text {
                    text: "Revolt AI Assistant"
                    color: "#F5F3FF"
                    font.pixelSize: 14
                    font.weight: Font.Bold
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 90
                    height: 22
                    radius: 11
                    color: "#20203A"
                    border.color: "#8B35FF"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Local Ollama"
                        color: "#B56BFF"
                        font.pixelSize: 10
                        font.weight: Font.Medium
                    }
                }

                // Collapse Button
                Button {
                    text: "✕"
                    flat: true
                    onClicked: {
                        islandWindow.currentState = "idle"
                    }
                }
            }

            // Chat / Content Output Box
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                TextArea {
                    id: responseText
                    readOnly: true
                    wrapMode: TextEdit.Wrap
                    color: "#F5F3FF"
                    font.pixelSize: 12
                    text: "Welcome to Revolt AI!\n\nAsk coding questions, diagnose terminal errors, generate git commit messages, or run local benchmarks.\nModel: Local Ollama (qwen2.5-coder:1.5b / offline ready)"
                    background: Rectangle {
                        color: "#080817"
                        radius: 12
                        border.color: "#20203A"
                    }
                }
            }

            // Quick Developer Action Chips
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Button {
                    text: "⚡ Git Commit Msg"
                    flat: true
                    onClicked: {
                        responseText.text += "\n\n[Analyzing staged git changes...]\nProposed: feat: enhance system architecture and add local AI tooling"
                    }
                }

                Button {
                    text: "🔍 Diagnose Error"
                    flat: true
                    onClicked: {
                        responseText.text += "\n\n[Diagnose Mode Active] Paste your compiler or terminal error below:"
                    }
                }
            }

            // Input Field Bar
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                TextField {
                    id: promptInput
                    Layout.fillWidth: true
                    placeholderText: "Ask Revolt AI or enter a coding command..."
                    placeholderTextColor: "#9290AA"
                    color: "#F5F3FF"
                    background: Rectangle {
                        color: "#20203A"
                        radius: 10
                        border.color: "#8B35FF"
                    }
                    onAccepted: sendBtn.clicked()
                }

                Button {
                    id: sendBtn
                    text: "Send"
                    highlighted: true
                    onClicked: {
                        if (promptInput.text.trim().length > 0) {
                            var query = promptInput.text
                            responseText.text += "\n\n> " + query + "\n\n[Local AI Thinking...]\n"
                            promptInput.text = ""
                        }
                    }
                }
            }
        }
    }
}
