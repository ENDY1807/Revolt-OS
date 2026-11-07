# Engineering Skills & Workflow Reference

This document tracks all agentic engineering skills, toolchains, and provenance loaded into the **RevoltOS** environment.

---

## 1. Loaded Skill Sets & Provenance

### 1.1. Superpowers Plugin
- **Repository:** `https://github.com/obra/superpowers`
- **Installation Method:** `agy plugin install https://github.com/obra/superpowers`
- **Installed Location:** `~/.gemini/config/plugins/superpowers`
- **Version:** 7.0.2
- **License:** MIT
- **Installed Skills (15):**
  1. `brainstorming`
  2. `diagnosing-superpowers`
  3. `dispatching-parallel-agents`
  4. `executing-plans`
  5. `finishing-a-development-branch`
  6. `receiving-code-review`
  7. `requesting-code-review`
  8. `subagent-driven-development`
  9. `systematic-debugging`
  10. `test-driven-development`
  11. `using-git-worktrees`
  12. `using-superpowers`
  13. `verification-before-completion`
  14. `writing-plans`
  15. `writing-skills`

### 1.2. Qt Agentic Skills
- **Repository:** `https://github.com/TheQtCompanyRnD/agent-skills`
- **Installation Method:** `agy plugin install https://github.com/TheQtCompanyRnD/agent-skills`
- **Installed Location:** `~/.gemini/config/plugins/qt-ai-skills`
- **Version:** 1.8.0
- **License:** The Qt Company R&D License
- **Installed Skills (13):**
  1. `qt-canvas2d`
  2. `qt-cmake-project`
  3. `qt-cpp-docs`
  4. `qt-cpp-review`
  5. `qt-figma-component-generation`
  6. `qt-figma-token-extraction`
  7. `qt-qml`
  8. `qt-qml-docs`
  9. `qt-qml-profiler`
  10. `qt-qml-review`
  11. `qt-qml-test`
  12. `qt-qml-test-run`
  13. `qt-ui-design`
- **Installed Subagents (2):**
  - `cpp-review-agent`
  - `qml-review-agent`

### 1.3. Linux Engineering Skills
- **Repository:** `https://github.com/peterbamuhigire/linux-skills`
- **Installation Method:** `agy plugin install https://github.com/peterbamuhigire/linux-skills`
- **Installed Location:** `~/.gemini/config/plugins/linux`
- **Version:** 1.1.0
- **License:** MIT
- **Capabilities:**
  - Debian administration, systemd service management, network stack debugging, storage mounting, performance monitoring, and package administration.

---

## 2. Engineering Verification Protocol

Before declaring any implementation milestone complete:
1. **Static Analysis & Syntax Validation:** All Shell, Python, QML, JSON, and C++ files must pass syntax verification (`bash -n`, `python -m py_compile`, `qmllint`, or schema checks).
2. **Deterministic Configuration Check:** Base Debian package lists in `distro/live-build/config/package-lists/` must cross-reference actual Debian Stable repository pools.
3. **Execution Verification:** No ISO creation or boot test will be claimed without execution artifacts and status codes logged in `docs/testing/`.

