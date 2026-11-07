#!/usr/bin/env bash
# ==============================================================================
# RevoltOS Docker Container Build Script
# Enables reproducible Debian Live ISO building on Windows/macOS/Linux via Docker
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
IMAGE_TAG="revoltos-builder:bookworm"

echo "=================================================="
echo "      RevoltOS Containerized ISO Builder          "
echo "=================================================="

if ! command -v docker >/dev/null 2>&1; then
    echo "[-] Error: docker is not installed or not running."
    echo "    On Windows: Ensure Docker Desktop is installed and running."
    exit 1
fi

echo "[*] Building Debian Bookworm builder image..."
docker build -t "$IMAGE_TAG" - <<'EOF'
FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
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
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
EOF

echo "[*] Spawning privileged container to execute build-iso.sh..."
docker run --rm --privileged \
    -v "$ROOT_DIR:/workspace" \
    -w /workspace \
    "$IMAGE_TAG" \
    ./scripts/build-iso.sh

echo "[+] Containerized build process completed."

