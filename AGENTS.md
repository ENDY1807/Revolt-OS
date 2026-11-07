# AGENTS.md — RevoltOS Autonomous Engineering Team

This document governs the engineering standards, roles, and collaborative behavior for agents working on **RevoltOS**.

---

## 1. Operating Rules & Discipline

1. **No Mockups / No Fake Implementations:**
   - Every file must be genuine, syntactically valid, and technically sound.
   - UI components must connect to real IPC/system daemons (D-Bus, systemd, PipeWire, NetworkManager).
   - Never fabricate terminal logs, test results, or hardware metrics.
2. **Superpowers Discipline:**
   - Adhere to the installed `superpowers` skills:
     - `brainstorming`: Clarify edge cases and technical constraints before coding.
     - `writing-plans` & `executing-plans`: Break large system milestones into testable slices.
     - `test-driven-development`: Write verification scripts/tests alongside system services.
     - `systematic-debugging`: Identify root causes without trial-and-error guessing.
     - `verification-before-completion`: Run explicit validation checks prior to declaring milestone exit.
3. **Qt / QML Guidelines (`qt-ai-skills`):**
   - Separate QML UI declarative layout from C++ or Python business logic.
   - Use `QQuickItem` / `QWindow` with Wayland layer-shell protocol (`wlr-layer-shell`).
   - Guard against unbounded resource usage and retain 60+ FPS animation budgets.
4. **Debian & Linux Systems Standards (`linux-skills`):**
   - Respect Debian Stable packaging standards, FHS (Filesystem Hierarchy Standard), and systemd unit specs.
   - Never execute unchecked scripts as root; isolate privileged operations behind Polkit.

---

## 2. Specialized Roles

| Role | Primary Responsibilities |
| :--- | :--- |
| **Linux Distribution Architect** | Base Debian selection, kernel parameters, repository pinning, Live Build configuration, Calamares integration. |
| **Wayland & Desktop Engineer** | Hyprland compositor configuration, layer-shell integration, Waybar, Rofi, Mako, input gestures. |
| **Native UI Engineer (Qt6/QML)** | Revolt Island pill geometry, spring animations, MPRIS media widget, system notification capsule, quick settings. |
| **AI Systems Engineer** | `revoltd` daemon, multi-provider adapters (OpenAI, Claude, Gemini, Ollama), streaming IPC, search scraper, Deep Research engine. |
| **Security & DevOps Engineer** | Polkit policy definitions, secret storage via Linux Keyring, permission tiers, ISO build automation, QEMU validation test harness. |

---

## 3. Communication & Error Reporting

- When an environment constraint is encountered (e.g. host running Windows without native Linux kernel namespaces for `live-build`), the agent must document the limitation transparently and provide automated scripts (`scripts/setup-build-env.sh`, `scripts/docker-build.sh`, `scripts/build-iso.sh`) to prepare the required Linux build environment.
- Never claim an ISO was generated or tested unless verifiable image artifacts and test results are produced.

