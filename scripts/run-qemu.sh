#!/usr/bin/env bash
# ==============================================================================
# RevoltOS QEMU Virtual Machine Test Runner
# Boots the ISO with Wayland-compatible graphics, sound, networking, and UEFI
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$ROOT_DIR/build"
ISO_PATH="${1:-"$BUILD_DIR/revoltos-amd64.iso"}"
DISK_IMAGE="$BUILD_DIR/revoltos-test-disk.qcow2"

echo "=================================================="
echo "          RevoltOS QEMU Test Environment          "
echo "=================================================="

if [ ! -f "$ISO_PATH" ]; then
    echo "[-] Error: Specified ISO image does not exist: $ISO_PATH"
    echo "    Please run: sudo ./scripts/build-iso.sh first."
    exit 1
fi

if ! command -v qemu-system-x86_64 >/dev/null 2>&1; then
    echo "[-] Error: qemu-system-x86_64 is not installed or not in PATH."
    echo "    Install with: sudo apt-get install qemu-system-x86"
    exit 1
fi

# Create a virtual 25 GB test disk if it doesn't already exist (to test installation)
if [ ! -f "$DISK_IMAGE" ]; then
    echo "[*] Creating 25 GB sparse QCOW2 test disk: $DISK_IMAGE"
    qemu-img create -f qcow2 "$DISK_IMAGE" 25G
fi

# Locate OVMF UEFI firmware if present
OVMF_OPTS=()
if [ -f "/usr/share/OVMF/OVMF_CODE.fd" ]; then
    OVMF_OPTS+=("-bios" "/usr/share/OVMF/OVMF_CODE.fd")
elif [ -f "/usr/share/ovmf/OVMF.fd" ]; then
    OVMF_OPTS+=("-bios" "/usr/share/ovmf/OVMF.fd")
fi

echo "[*] Booting RevoltOS Live ISO in QEMU..."
echo "    RAM: 4096 MB | Cores: 4 | Disk: $DISK_IMAGE | ISO: $ISO_PATH"

qemu-system-x86_64 \
    -enable-kvm 2>/dev/null || true \
    -m 4096 \
    -smp 4 \
    -cpu host 2>/dev/null || -cpu max \
    "${OVMF_OPTS[@]}" \
    -boot d \
    -cdrom "$ISO_PATH" \
    -drive file="$DISK_IMAGE",if=virtio,format=qcow2 \
    -vga virtio \
    -display default \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0 \
    -device intel-hda \
    -device hda-duplex \
    -device usb-ehci \
    -device usb-tablet
