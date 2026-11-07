# RevoltOS Developer Guide

This document provides setup instructions, development workflows, and testing procedures for engineers contributing to **RevoltOS**.

---

## 1. Development Environment Overview

RevoltOS is a Debian-based Linux distribution. The distribution building pipeline requires standard Linux kernel facilities:
- Root privileges (`sudo`) for `debootstrap`, `mknod`, `chroot`, and loopback mounts.
- Linux filesystem with support for POSIX file permissions, symlinks, and device nodes (`ext4`, `Btrfs`, or `xfs`).
- Debian `live-build`, `squashfs-tools`, and `xorriso`.

### 1.1. Host Architecture Matrix & Notes

| Host Environment | Build Capability | Recommended Setup |
| :--- | :--- | :--- |
| **Debian 12 / Ubuntu 24.04 (Native / Bare Metal)** | **Full Native ISO Build** | Direct execution of `./scripts/build-iso.sh` |
| **Linux VM (QEMU / KVM / VirtualBox)** | **Full Native ISO Build** | 4 CPU cores, 8 GB RAM, 30 GB virtual disk formatted as ext4 |
| **Windows 11 (WSL2 Debian)** | **Full Native ISO Build** | Install WSL2 Debian (`wsl --install -d Debian`) |
| **Windows 11 (Host Filesystem FAT32/NTFS)** | **Code, QML & Daemon Development** | Develop components, run tests via Node/Python/Qt; build ISO inside VM/WSL |

> [!WARNING]
> If your repository resides on a FAT32 volume (such as a USB drive), FAT32 cannot store single files greater than 4 GB and does not support POSIX symlinks or file ownership permissions. Always output the ISO image or run the live-build chroot on an `ext4` or `NTFS` volume (e.g. Drive D: or inside a WSL2 virtual disk).

---

## 2. Setting Up the Development Toolchain

### 2.1. Debian / Ubuntu Build Host Setup

Run the automated environment setup script:
```bash
sudo ./scripts/setup-build-env.sh
```

Or install dependencies manually:
```bash
sudo apt-get update
sudo apt-get install -y \
    live-build \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-efi \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    dosfstools \
    qemu-system-x86 \
    python3 \
    python3-pip \
    qt6-base-dev \
    qml6-module-qtquick \
    qml6-module-qtquick-controls \
    cmake \
    git
```

---

## 3. Directory Layout & Workflow

- **`desktop/`**: Hyprland configuration, Waybar notch layout, Rofi theme, and Mako notifications.
- **`revolt-island/`**: Qt6/QML desktop shell. Run standalone with `qml6 revolt-island/core/Main.qml` or via CMake build.
- **`revolt-ai/`**: Python async AI service (`revoltd`). Run with `python3 -m revolt-ai.backend.server`.
- **`distro/live-build/`**: Debian live-build hooks, package lists, and chroot inclusions.
- **`scripts/`**: Build automation, linting, and QEMU virtual machine runners.

---

## 4. Verification & Testing Commands

### 4.1. Validate All Configurations
```bash
# Validates shell scripts, Hyprland configs, package manifests, and QML syntax
./scripts/validate-configs.sh
```

### 4.2. Run Revolt AI Backend Unit & Integration Tests
```bash
python3 -m unittest discover -s tests/ai -p "test_*.py"
```

### 4.3. Build Minimal Live ISO
```bash
sudo ./scripts/build-iso.sh --profile minimal
```

### 4.4. Test in Virtual Machine
```bash
./scripts/run-qemu.sh build/revoltos-amd64.iso
```

