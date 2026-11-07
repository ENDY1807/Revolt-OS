# RevoltOS System Requirements & Hardware Targets

RevoltOS is engineered to scale across a spectrum of x86_64 hardware, dynamically adjusting visual fidelity and background resource consumption based on detected hardware profiles.

---

## 1. Hardware Tiers

### 1.1. Minimum Specification (Target: Low Resource Mode)
- **Processor:** 64-bit x86_64 Dual-Core CPU @ 2.0 GHz (Intel Core 2 Duo / AMD Athlon 64 X2 or newer).
- **RAM:** 4.0 GB physical memory (ZRAM compressed swap enabled by default).
- **Storage:** 25 GB free disk space (HDD or SSD, ext4 partition).
- **Graphics:** Intel HD Graphics 3000+, AMD Radeon HD 6000+, or NVIDIA GeForce with Nouveau.
- **Display:** 1280x720 minimum resolution.

### 1.2. Recommended Specification (Target: Balanced Mode)
- **Processor:** 64-bit Quad-Core CPU (Intel Core i5 / AMD Ryzen 3 or newer).
- **RAM:** 8.0 GB physical memory.
- **Storage:** 50 GB free disk space on Solid State Drive (SATA or NVMe SSD).
- **Graphics:** Intel UHD / Iris Xe, AMD Radeon Vega / RDNA, or NVIDIA GTX 10-series / RTX.
- **Display:** 1920x1080 Full HD @ 60Hz+.

### 1.3. High-Performance / Creator & Gaming Specification (Target: Performance Mode)
- **Processor:** 8+ Core CPU (Intel Core i7/i9, AMD Ryzen 7/9).
- **RAM:** 16.0 GB to 32.0 GB RAM.
- **Storage:** 100+ GB NVMe PCIe Gen 4 SSD.
- **Graphics:** Dedicated GPU with 6+ GB VRAM (AMD Radeon RX 6000/7000, NVIDIA RTX 30/40 series).
- **Display:** 2560x1440 or 4K with variable refresh rate (FreeSync / G-Sync, 144Hz+).

---

## 2. Dynamic Performance Profiles

RevoltOS includes an integrated hardware-detection daemon (`revoltos-profile-daemon`) that activates one of three profiles:

| Feature / Setting | Low Resource Mode | Balanced Mode (Default) | Performance Mode |
| :--- | :--- | :--- | :--- |
| **Hyprland Blur** | Disabled (`blur = false`) | Subtle acrylic (`passes = 2`) | Deep dual-cavity (`passes = 4`) |
| **Hyprland Shadows** | Disabled | 12px subtle drop shadow | 24px ambient glow shadow |
| **Window Animations** | Linear 0.1s or Off | Smooth Bezier 0.35s | Physics spring transitions |
| **Revolt Island Visuals**| Opaque surface `#15152B` | 85% opacity with blur | Frosted glass with glow borders |
| **ZRAM Compression** | LZ4 (up to 75% RAM) | ZSTD (50% RAM) | ZSTD (25% RAM) |
| **Revolt AI Mode** | Cloud-only streaming | Cloud + small Ollama models | Cloud + Local Ollama GPU offload |
| **GameMode Governor** | `powersave` / `schedutil` | `ondemand` / `schedutil` | `performance` forced |
| **Background Indexing** | Disabled when on battery | Throttled I/O | Full high-speed parallel indexing |
