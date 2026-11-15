import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: installerWindow
    title: "RevoltOS Installer"
    width: 960
    height: 640
    visible: true
    color: "#080B16"

    property int currentStep: 0
    property string selectedLanguage: "Bahasa Indonesia"
    property string selectedDE: "Hyprland"
    property string selectedTheme: "Revolt Dark"
    property string selectedType: "Recommended"
    property bool enableAI: true
    property bool enableGaming: true

    // Left Navigation Stepper Sidebar
    Rectangle {
        id: sidebar
        width: 220
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "#0B0D14"
        border.color: "#191F31"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16

            RowLayout {
                spacing: 12
                Image {
                    source: "/usr/share/revoltos/branding/logo/variants/revoltos-symbol-r.svg"
                    sourceSize.width: 32
                    sourceSize.height: 32
                }
                Text {
                    text: "RevoltOS"
                    font.family: "Inter"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: "#F8FAFC"
                }
            }

            Rectangle { height: 1; Layout.fillWidth: true; color: "#191F31" }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                interactive: false
                model: [
                    "Welcome",
                    "Language",
                    "Configuration",
                    "Disk & Partition",
                    "User Account",
                    "Summary",
                    "Installing",
                    "Finished"
                ]
                delegate: Rectangle {
                    width: parent.width
                    height: 38
                    radius: 8
                    color: index === installerWindow.currentStep ? "#1F1B3E" : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        spacing: 10

                        Rectangle {
                            width: 8
                            height: 8
                            radius: 4
                            color: index === installerWindow.currentStep ? "#8B5CF6" : (index < installerWindow.currentStep ? "#10B981" : "#475569")
                        }

                        Text {
                            text: modelData
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: index === installerWindow.currentStep ? Font.SemiBold : Font.Normal
                            color: index === installerWindow.currentStep ? "#F8FAFC" : "#9299AA"
                        }
                    }
                }
            }
        }
    }

    // Right Main Content Flow
    Rectangle {
        anchors.left: sidebar.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "#080B16"

        StackLayout {
            id: contentStack
            anchors.fill: parent
            anchors.margins: 40
            currentIndex: installerWindow.currentStep

            // ================= STEP 0: WELCOME =================
            ColumnLayout {
                spacing: 24
                Item { Layout.fillHeight: true }

                Image {
                    Layout.alignment: Qt.AlignHCenter
                    source: "/usr/share/revoltos/branding/logo/variants/revoltos-symbol-r.svg"
                    sourceSize.width: 140
                    sourceSize.height: 140
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Welcome to RevoltOS"
                    font.family: "Inter"
                    font.pixelSize: 32
                    font.weight: Font.Bold
                    color: "#F8FAFC"
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "A modern, powerful, and intelligent Linux distribution.\nLet's set up your system."
                    font.family: "Inter"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    color: "#9299AA"
                    lineHeight: 1.3
                }

                Item { Layout.fillHeight: true }

                RowLayout {
                    Layout.fillWidth: true
                    Item { Layout.fillWidth: true }
                    Button {
                        text: "Next  →"
                        contentItem: Text {
                            text: parent.text
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.weight: Font.SemiBold
                            font.pixelSize: 14
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            implicitWidth: 140
                            implicitHeight: 44
                            radius: 10
                            color: parent.hovered ? "#7C3AED" : "#8B5CF6"
                        }
                        onClicked: installerWindow.currentStep++
                    }
                }
            }

            // ================= STEP 1: SELECT LANGUAGE =================
            ColumnLayout {
                spacing: 20

                Text {
                    text: "Select Your Language"
                    font.family: "Inter"
                    font.pixelSize: 26
                    font.weight: Font.Bold
                    color: "#F8FAFC"
                }

                Text {
                    text: "Choose your preferred system language."
                    font.family: "Inter"
                    font.pixelSize: 14
                    color: "#9299AA"
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: [
                        "English (United States)",
                        "Bahasa Indonesia",
                        "Español (España)",
                        "Français",
                        "Deutsch",
                        "日本語 (Japanese)",
                        "한국어 (Korean)",
                        "Русский"
                    ]
                    delegate: Rectangle {
                        width: parent.width
                        height: 48
                        radius: 10
                        color: modelData === installerWindow.selectedLanguage ? "#2D1B69" : (mouseArea.containsMouse ? "#191F31" : "#111625")
                        border.color: modelData === installerWindow.selectedLanguage ? "#8B5CF6" : "#191F31"
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 18
                            anchors.rightMargin: 18

                            Text {
                                text: modelData
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: modelData === installerWindow.selectedLanguage ? Font.SemiBold : Font.Normal
                                color: modelData === installerWindow.selectedLanguage ? "#F8FAFC" : "#CBD5E1"
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                visible: modelData === installerWindow.selectedLanguage
                                text: "✓"
                                font.pixelSize: 16
                                color: "#8B5CF6"
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: installerWindow.selectedLanguage = modelData
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Button {
                        text: "← Back"
                        onClicked: installerWindow.currentStep--
                    }
                    Item { Layout.fillWidth: true }
                    Button {
                        text: "Next  →"
                        contentItem: Text { text: parent.text; color: "#FFFFFF"; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                        background: Rectangle { implicitWidth: 140; implicitHeight: 44; radius: 10; color: "#8B5CF6" }
                        onClicked: installerWindow.currentStep++
                    }
                }
            }

            // ================= STEP 2: CONFIGURE SYSTEM =================
            ColumnLayout {
                spacing: 20

                Text {
                    text: "Configure Your System"
                    font.family: "Inter"
                    font.pixelSize: 26
                    font.weight: Font.Bold
                    color: "#F8FAFC"
                }

                Text {
                    text: "Customize your desktop environment and optional developer features."
                    font.family: "Inter"
                    font.pixelSize: 14
                    color: "#9299AA"
                }

                // Desktop Environment Option
                Rectangle {
                    Layout.fillWidth: true
                    height: 64
                    radius: 12
                    color: "#111625"
                    border.color: "#191F31"
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        Text { text: "Desktop Environment"; color: "#F8FAFC"; font.weight: Font.SemiBold; font.pixelSize: 14 }
                        Item { Layout.fillWidth: true }
                        ComboBox {
                            model: ["Hyprland (Wayland Native)", "XFCE Traditional (Zorin Style)"]
                            currentIndex: 0
                            onCurrentTextChanged: installerWindow.selectedDE = currentText
                        }
                    }
                }

                // Theme Selection
                Rectangle {
                    Layout.fillWidth: true
                    height: 64
                    radius: 12
                    color: "#111625"
                    border.color: "#191F31"
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        Text { text: "System Theme"; color: "#F8FAFC"; font.weight: Font.SemiBold; font.pixelSize: 14 }
                        Item { Layout.fillWidth: true }
                        ComboBox {
                            model: ["Revolt Dark (Default)", "Midnight Purple", "Revolt Light", "Minimal Dark"]
                            currentIndex: 0
                            onCurrentTextChanged: installerWindow.selectedTheme = currentText
                        }
                    }
                }

                // Feature Checkboxes
                CheckBox {
                    text: "Enable Built-in Revolt AI Assistant (Local & Cloud)"
                    checked: installerWindow.enableAI
                    onToggled: installerWindow.enableAI = checked
                }

                CheckBox {
                    text: "Install Gaming & Compatibility Support (Steam, Proton, Wine, Waydroid)"
                    checked: installerWindow.enableGaming
                    onToggled: installerWindow.enableGaming = checked
                }

                Item { Layout.fillHeight: true }

                RowLayout {
                    Layout.fillWidth: true
                    Button { text: "← Back"; onClicked: installerWindow.currentStep-- }
                    Item { Layout.fillWidth: true }
                    Button {
                        text: "Continue  →"
                        contentItem: Text { text: parent.text; color: "#FFFFFF"; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                        background: Rectangle { implicitWidth: 140; implicitHeight: 44; radius: 10; color: "#8B5CF6" }
                        onClicked: installerWindow.currentStep++
                    }
                }
            }

            // ================= STEP 3+: SUMMARY & INSTALL =================
            ColumnLayout {
                spacing: 20

                Text {
                    text: "Ready to Install RevoltOS"
                    font.family: "Inter"
                    font.pixelSize: 26
                    font.weight: Font.Bold
                    color: "#F8FAFC"
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: "#111625"
                    border.color: "#191F31"

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 12

                        Text { text: "Summary of Configuration:"; color: "#8B5CF6"; font.bold: true; font.pixelSize: 16 }
                        Text { text: "• Language: " + installerWindow.selectedLanguage; color: "#E2E8F0"; font.pixelSize: 14 }
                        Text { text: "• Desktop Environment: " + installerWindow.selectedDE; color: "#E2E8F0"; font.pixelSize: 14 }
                        Text { text: "• Theme: " + installerWindow.selectedTheme; color: "#E2E8F0"; font.pixelSize: 14 }
                        Text { text: "• Revolt AI: " + (installerWindow.enableAI ? "Enabled" : "Disabled"); color: "#E2E8F0"; font.pixelSize: 14 }
                        Text { text: "• Gaming Stack: " + (installerWindow.enableGaming ? "Enabled" : "Disabled"); color: "#E2E8F0"; font.pixelSize: 14 }
                        Text { text: "• Target Disk: Auto-partition root on available primary drive"; color: "#E2E8F0"; font.pixelSize: 14 }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Button { text: "← Back"; onClicked: installerWindow.currentStep-- }
                    Item { Layout.fillWidth: true }
                    Button {
                        text: "Install Now  ✓"
                        contentItem: Text { text: parent.text; color: "#FFFFFF"; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                        background: Rectangle { implicitWidth: 160; implicitHeight: 44; radius: 10; color: "#10B981" }
                        onClicked: {
                            console.log("[Installer] Initiating real disk installation...")
                        }
                    }
                }
            }
        }
    }
}
