# RevoltOS Compatibility Matrix

This document defines verified interoperability across hardware platforms, display drivers, Linux kernels, and desktop Wayland protocols in **RevoltOS**.

---

## 1. Hardware Architecture & Platform Support

| Architecture | Status | Minimum Spec | Recommended Spec | Tested Environments |
| :--- | :--- | :--- | :--- | :--- |
| **x86_64 / AMD64** | **Tier 1 (Primary)** | Dual-Core 64-bit, 4 GB RAM, 25 GB disk | 6-Core+, 16 GB RAM, NVMe SSD | QEMU/KVM, Bare Metal AMD & Intel |
| **ARM64 (aarch64)** | Tier 3 (Planned) | Quad-Core ARMv8+, 4 GB RAM | 8-Core ARMv9, 8 GB RAM | Deferred to v2.0 |

---

## 2. Graphics Driver Compatibility (Wayland on Hyprland)

| GPU Vendor | Driver Stack | Wayland Status | Special Kernel Parameters / Config |
| :--- | :--- | :--- | :--- |
| **Intel Integrated / Arc** | Mesa (`iris`, `crocus`, `anv`) | **Native / Flawless** | Out-of-the-box DRI3, TearFree, Vulkan supported. |
| **AMD Radeon** | Mesa (`amdgpu`, `radeonsi`, `radv`)| **Native / Flawless** | Zero configuration required; optimal Hyprland compatibility. |
| **NVIDIA (Modern RTX / GTX 16xx+)** | Proprietary (`nvidia-driver`) 535+ | **Supported via GBM** | `env = LIBVA_DRIVER_NAME,nvidia`<br>`env = GBM_BACKEND,nvidia-drm`<br>`env = __GLX_VENDOR_LIBRARY_NAME,nvidia`<br>`cursor:no_hardware_cursors = true` |
| **NVIDIA (Legacy / Nouveau)** | Nouveau / Open Driver | **Functional (2D/Basic)**| Fallback mode; blur animations disabled automatically. |
| **Virtual Machine (QEMU / KVM)** | `virtio-gpu` / `qxl` | **Supported (with virgl)** | `qemu-system-x86_64 -vga virtio -display gtk,gl=on` |

---

## 3. Desktop Subsystem Compatibility

| Subsystem | Underlying Technology | IPC Mechanism | Compatibility Fallback |
| :--- | :--- | :--- | :--- |
| **Revolt Island** | Qt6 / QML + Wayland Layer Shell | D-Bus Session Bus | Top Floating Window if Layer Shell unavailable |
| **Audio Pipeline** | PipeWire + WirePlumber | D-Bus / ALSA / PulseAudio | Native ALSA fallback |
| **Network Configuration** | NetworkManager + `nmcli` | D-Bus (`org.freedesktop.NetworkManager`) | systemd-networkd |
| **Display Configuration**| `wlr-randr` / Hyprland IPC | Unix Domain Socket (`$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock`) | Hyprland config reload |
| **Package Management** | APT / dpkg / PackageKit | Polkit + D-Bus | Direct CLI APT invocation |
| **Live Installer** | Calamares (Qt6) | Root D-Bus / Python Modules | Command-line `debootstrap` installer |
