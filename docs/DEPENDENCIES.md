# RevoltOS Dependencies Specification

This document details every foundational dependency in **RevoltOS**, verifying Debian package availability, upstream licensing, runtime/build requirements, and security postures.

---

## 1. Compositor & Wayland Display Stack

### 1.1. Hyprland
- **Upstream:** `https://github.com/hyprwm/Hyprland`
- **License:** BSD 3-Clause
- **Debian Stable Availability:** Backports / RevoltOS Dedicated APT Pool (`hyprland`). In Debian 12 Bookworm, Hyprland requires building with `wlroots` or using the backports/pre-built Debian package repository.
- **Runtime Dependencies:** `libwayland-client0`, `libwayland-server0`, `libgl1-mesa-dri`, `xwayland`, `seatd`, `libinput10`, `libxkbcommon0`, `libcairo2`, `libpango-1.0-0`.
- **Build Dependencies:** `meson`, `ninja-build`, `cmake`, `libdrm-dev`, `libgbm-dev`, `libseat-dev`, `wayland-protocols`.
- **Compatibility:** Direct compatibility with `wlr-layer-shell` for Revolt Island and Waybar.
- **Security:** Sandboxed Wayland display server; drops root privileges after session startup.
- **Update Strategy:** Stable minor version releases tested against the Revolt Island layer-shell plugin.

### 1.2. hyprlock, hypridle, hyprpaper
- **Upstream:** `https://github.com/hyprwm/hyprlock`, `hypridle`, `hyprpaper`
- **License:** BSD 3-Clause
- **Debian Package:** Available via RevoltOS desktop package list / backports.
- **Role:** Screen locking (`pam` authentication), idle power management, and wallpaper rendering.

### 1.3. xdg-desktop-portal-hyprland
- **Upstream:** `https://github.com/hyprwm/xdg-desktop-portal-hyprland`
- **License:** BSD 3-Clause
- **Debian Package:** `xdg-desktop-portal-hyprland` / `xdg-desktop-portal-wlr`
- **Role:** Sandboxed file open/save, screen casting via PipeWire, and token authorization.

---

## 2. Desktop Environment Components

| Component | Project Repository | License | Debian Stable Package | Role |
| :--- | :--- | :--- | :--- | :--- |
| **Waybar** | `https://github.com/Alexays/Waybar` | MIT | `waybar` (Debian 12: v0.9.17+) | System status panel with Island notch |
| **Kitty** | `https://github.com/kovidgoyal/kitty` | GPL-3.0 | `kitty` | GPU-accelerated Wayland terminal |
| **Thunar** | `https://gitlab.xfce.org/xfce/thunar` | GPL-2.0+ | `thunar` | High-performance, lightweight file manager |
| **Mako** | `https://github.com/emersion/mako` | MIT | `mako-notifier` | Wayland notification fallback daemon |
| **Rofi-Wayland**| `https://github.com/lbonn/rofi` | MIT | `rofi-wayland` | Application launcher and window switcher |
| **Grim & Slurp**| `https://github.com/emersion/grim` | MIT | `grim`, `slurp` | Wayland region and full screen capture |
| **wl-clipboard**| `https://github.com/bugaevc/wl-clipboard`| GPL-3.0 | `wl-clipboard` | Wayland command-line clipboard manager |

---

## 3. Native Desktop & GUI Runtimes

### 3.1. Qt6 & QML (Revolt Island & Native Settings)
- **Upstream:** `https://github.com/qt/qtbase`, `https://github.com/qt/qtdeclarative`
- **License:** LGPLv3 / GPLv3
- **Debian Stable Availability:** `qt6-base-dev`, `qml6-module-qtquick`, `qml6-module-qtquick-controls`, `qml6-module-qtquick-layouts`, `libqt6waylandclient6`.
- **Role:** Powers Revolt Island top-center pill shell and the Revolt Settings application.

### 3.2. PySide6 / Python 3
- **Upstream:** `https://wiki.qt.io/Qt_for_Python`
- **License:** LGPLv3
- **Debian Package:** `python3-pyside6`, `python3-pyside6.qtquick`
- **Role:** High-velocity desktop scripting and reactive system service bindings.

---

## 4. System Services & Audio/Networking

| Component | Repository | License | Debian Package | Function |
| :--- | :--- | :--- | :--- | :--- |
| **PipeWire** | `https://github.com/PipeWire/pipewire` | MIT | `pipewire`, `pipewire-pulse` | Next-gen low-latency multimedia routing |
| **WirePlumber**| `https://gitlab.freedesktop.org/pipewire/wireplumber` | MIT | `wireplumber` | PipeWire session and policy manager |
| **NetworkManager**| `https://github.com/NetworkManager/NetworkManager` | GPL-2.0+ | `network-manager` | Wi-Fi, Ethernet, and VPN connection manager |
| **Polkit** | `https://gitlab.freedesktop.org/polkit/polkit` | LGPL-2.0+ | `polkitd`, `libpolkit-gobject-1-0` | Fine-grained privilege escalation gate |
| **ZRAM** | Linux Kernel subsystem | GPL-2.0 | `zram-tools` / native systemd | In-RAM compressed swap space |
| **Flatpak** | `https://github.com/flatpak/flatpak` | LGPL-2.1+ | `flatpak` | Optional sandboxed application container |

---

## 5. AI Runtimes & Inference

### 5.1. Ollama (Local AI Inference)
- **Upstream:** `https://github.com/ollama/ollama`
- **License:** MIT
- **Availability:** Standalone Linux x86_64 binary / systemd user service.
- **Role:** Offline local language models (Llama 3, Qwen 2.5, DeepSeek R1, Mistral).

### 5.2. Cloud AI SDKs
- Multi-provider HTTP REST client integrated into `revoltd` using standard `httpx` async client.
- Zero heavyweight vendor lock-in dependencies; uses standard JSON schema requests with SSE (Server-Sent Events) streaming.

---

## 6. Installer & Distribution Tooling

### 6.1. Calamares Installer
- **Upstream:** Active repository at `https://github.com/calamares/calamares`
- **License:** GPL-3.0
- **Debian Package:** `calamares`, `calamares-settings-debian`
- **Role:** Graphical, user-friendly live distribution installer with EFI/GRUB, Btrfs, and ext4 partitioning.

### 6.2. Debian Live Build
- **Upstream:** `https://salsa.debian.org/live-team/live-build`
- **License:** GPL-3.0+
- **Debian Package:** `live-build`, `debootstrap`, `squashfs-tools`, `xorriso`
- **Role:** Official Debian framework for assembling, customizing, and mastering ISO images.

