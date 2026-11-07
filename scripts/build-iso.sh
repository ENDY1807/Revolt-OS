#!/usr/bin/env bash
# ==============================================================================
# RevoltOS Debian Live ISO Build Script
# Runs lb config, copies overlay configurations, builds squashfs, produces ISO
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$ROOT_DIR/build"
LIVE_BUILD_DIR="$ROOT_DIR/distro/live-build"
ISO_NAME="revoltos-amd64.iso"
OUTPUT_ISO="$BUILD_DIR/$ISO_NAME"

echo "=================================================="
echo "          RevoltOS Live ISO Builder               "
echo "=================================================="

# 1. Privilege Check
if [ "$(id -u)" -ne 0 ]; then
    echo "[-] Error: ISO generation requires root privileges for chroot & mknod."
    echo "    Please run with: sudo $0"
    exit 1
fi

# 2. Dependency Verification
REQUIRED_TOOLS=("lb" "debootstrap" "mksquashfs" "xorriso")
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "[-] Missing required build dependency: $tool"
        echo "    Run: sudo ./scripts/setup-build-env.sh"
        exit 1
    fi
done

# 3. Destination Directory Preparation
mkdir -p "$BUILD_DIR"

# 4. Navigate to live-build directory
cd "$LIVE_BUILD_DIR"

echo "[*] Cleaning previous live-build state..."
lb clean --purge || true

echo "[*] Running lb config with RevoltOS distribution profile..."
if [ -x "auto/config" ]; then
    ./auto/config
else
    lb config
fi

echo "[*] Injecting RevoltOS Desktop, Theme, and Island overlays into chroot..."
mkdir -p config/includes.chroot/etc/skel/.config/hypr
mkdir -p config/includes.chroot/etc/skel/.config/waybar
mkdir -p config/includes.chroot/etc/skel/.config/rofi
mkdir -p config/includes.chroot/etc/skel/.config/mako
mkdir -p config/includes.chroot/usr/share/revoltos/branding

# Sync Desktop configs
cp "$ROOT_DIR/desktop/hyprland/hyprland.conf" config/includes.chroot/etc/skel/.config/hypr/
cp "$ROOT_DIR/desktop/waybar/config.jsonc" config/includes.chroot/etc/skel/.config/waybar/
cp "$ROOT_DIR/desktop/waybar/style.css" config/includes.chroot/etc/skel/.config/waybar/
cp "$ROOT_DIR/desktop/launcher/rofi-hyprland.rasi" config/includes.chroot/etc/skel/.config/rofi/revoltos.rasi
cp "$ROOT_DIR/desktop/notifications/mako.conf" config/includes.chroot/etc/skel/.config/mako/config
cp "$ROOT_DIR/branding/logo/revoltos-logo.svg" config/includes.chroot/usr/share/revoltos/branding/

echo "[*] Executing Debian live build (lb build)... This will download base packages and assemble squashfs."
lb build

# 5. Move and verify resulting ISO
GENERATED_FILE=$(find . -maxdepth 1 -name "*.iso" | head -n 1)

if [ -n "$GENERATED_FILE" ] && [ -f "$GENERATED_FILE" ]; then
    mv "$GENERATED_FILE" "$OUTPUT_ISO"
    ISO_SIZE_BYTES=$(stat -c%s "$OUTPUT_ISO" 2>/dev/null || stat -f%z "$OUTPUT_ISO")
    ISO_SIZE_MB=$(( ISO_SIZE_BYTES / 1024 / 1024 ))
    
    echo "[+] SUCCESS: RevoltOS ISO created successfully!"
    echo "    Output File : $OUTPUT_ISO"
    echo "    Image Size  : ${ISO_SIZE_MB} MB"
    
    # Compute SHA256
    echo "[*] Computing SHA256 checksum..."
    sha256sum "$OUTPUT_ISO" > "$OUTPUT_ISO.sha256"
    cat "$OUTPUT_ISO.sha256"
else
    echo "[-] Error: lb build completed but no .iso output file was detected."
    exit 1
fi

