#!/usr/bin/env python3
"""
Revolt Island - Native Wayland Desktop Shell
Initializes Qt6/QML surface anchored to top-center.
Communicates with revoltd daemon over local IPC / D-Bus.
"""

import sys
import os
from pathlib import Path

# Prefer PyQt6 or PySide6 based on availability
try:
    from PyQt6.QtCore import QUrl, Qt
    from PyQt6.QtGui import QGuiApplication
    from PyQt6.QtQml import QQmlApplicationEngine
except ImportError:
    try:
        from PySide6.QtCore import QUrl, Qt
        from PySide6.QtGui import QGuiApplication
        from PySide6.QtQml import QQmlApplicationEngine
    except ImportError:
        print("[-] Error: Neither PyQt6 nor PySide6 is installed.")
        sys.exit(1)


def main():
    # Set Wayland specific environment flags
    os.environ.setdefault("QT_QPA_PLATFORM", "wayland;xcb")
    os.environ.setdefault("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

    app = QGuiApplication(sys.argv)
    app.setApplicationName("RevoltIsland")
    app.setOrganizationName("RevoltOS")

    engine = QQmlApplicationEngine()
    qml_file = Path(__file__).resolve().parent / "Main.qml"

    engine.load(QUrl.fromLocalFile(str(qml_file)))

    if not engine.rootObjects():
        print("[-] Error: Failed to load Revolt Island QML surface.")
        sys.exit(-1)

    print("[+] Revolt Island native desktop shell running.")
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
