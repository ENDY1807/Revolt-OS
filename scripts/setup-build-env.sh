#!/usr/bin/env bash
# ==============================================================================
# RevoltOS Build Environment Setup Script
# Installs all required tooling for Debian live-build and QEMU virtualization
# ==============================================================================

set -euo pipefail

echo "=================================================="
echo "    RevoltOS Build Environment Provisioner       "
echo "=================================================="

if [ "$(id -u)" -ne 0 ]; then
    echo "[-] Error: This setup script must be executed with root privileges."
    echo "    Please run: sudo $0"
    exit 1
fi

echo "[*] Updating APT package repositories..."
apt-get update -y

echo "[*] Installing Debian Live Build and ISO mastering toolchain..."
apt-get install -y --no-install-recommends \
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
    parted \
    rsync \
    git \
    curl \
    wget \
    ca-certificates

echo "[*] Installing Virtualization test tools (QEMU & OVMF UEFI)..."
apt-get install -y --no-install-recommends \
    qemu-system-x86 \
    qemu-utils \
    ovmf

echo "[*] Installing native compilation and Python runtimes..."
apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    cmake \
    build-essential

echo "[+] Build environment provisioning completed successfully!"
echo "    You can now build the ISO using: sudo ./scripts/build-iso.sh"

