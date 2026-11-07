# RevoltOS Build Environment & ISO Generation Specification

This document details the exact requirements, constraints, and operational commands for building the **RevoltOS** Debian-based Live ISO.

---

## 1. Environment Analysis & Host Constraints

### 1.1. Host Assessment
- **Current Development Host:** Microsoft Windows 11 Pro (x86_64).
- **Physical RAM:** ~3.75 GB Total (~480 MB Free).
- **Workspace Filesystem:** `E:\` (FAT32, 5.84 GB Free).
- **Alternative Filesystem:** `D:\` (NTFS, 16.18 GB Free).

### 1.2. Engineering Constraints
1. **Linux Kernel Primitives:** Debian `live-build` (`lb config`, `lb build`) creates a complete root filesystem using `debootstrap`. This requires Linux kernel capabilities:
   - Root privilege (`sudo`) to create character/block device nodes in `/dev/` (`mknod`).
   - `mount -t proc`, `mount -t sysfs`, and `mount -o loop` for squashfs creation.
   - Filesystem with POSIX file permissions (`chmod`, `chown`, suid bits, symlinks).
2. **FAT32 Limitations:**
   - FAT32 does not support POSIX file ownership (`root:root`, `www-data`, etc.).
   - FAT32 enforces a maximum single file size limit of **4.0 GB**. A full live ISO image with desktop packages may exceed or approach this limit.
   - **Resolution:** All ISO build outputs and chroot intermediate caches must reside on an NTFS partition (e.g. `D:\revoltos-build`) or inside a Linux virtual disk / container.
3. **Execution Paths for ISO Building:**
   - **Option A (WSL2 Debian):** Run `wsl --install -d Debian`, clone the repo inside `/home/user/revoltos`, and run `./scripts/build-iso.sh`.
   - **Option B (Docker Linux Container):** Run `docker run --privileged -v /var/run/docker.sock ...` (requires Docker Desktop on Windows).
   - **Option C (Dedicated Linux VM / CI Runner):** Run in a standard Debian 12 / Ubuntu 24.04 QEMU/VirtualBox VM or GitHub Actions runner.

---

## 2. Automated ISO Build Pipeline

The build pipeline consists of 4 reproducible stages implemented in `scripts/build-iso.sh` and `distro/live-build/`:

```
+-------------------------------------------------------------------------------+
| STAGE 1: SYSTEM ENVIRONMENT & ARCHIVE VALIDATION                              |
| - Verify live-build, debootstrap, squashfs-tools, xorriso                      |
| - Setup Debian Bookworm / Trixie repositories and backports                   |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
| STAGE 2: CONFIGURATION & PACKAGE LISTING (lb config)                          |
| - Architecture: amd64                                                         |
| - Distribution: bookworm                                                      |
| - Linux Kernel: linux-image-amd64                                             |
| - Package Lists: base, hyprland-desktop, multimedia-audio, hardware, installer|
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
| STAGE 3: CHROOT CUSTOMIZATION & HOOKS (lb chroot)                             |
| - Inject /etc/os-release (RevoltOS branding)                                  |
| - Deploy Hyprland, Waybar, Rofi, and Mako default configurations to /etc/skel |
| - Deploy Revolt Island native desktop shell and revoltd service               |
| - Enable systemd services (NetworkManager, pipewire, zram, revoltd)           |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
| STAGE 4: BINARY & ISO MASTERING (lb binary)                                   |
| - Build squashfs compressed filesystem                                        |
| - Configure GRUB2 EFI and ISOLINUX BIOS bootloaders                           |
| - Generate hybrid ISO image: build/revoltos-amd64.iso                         |
| - Compute SHA256 checksums                                                    |
+-------------------------------------------------------------------------------+
```

