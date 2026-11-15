#!/usr/bin/env python3
"""
RevoltOS Developer Environment Manager (revolt-dev)
Inspired by Fedora Toolbx, CachyOS performance presets, and modern developer CLI tools.
Provides:
  - revolt-dev doctor: Checks compiler toolchains, runtimes, containers, and AI services.
  - revolt-dev preset: Configures complete dev stacks (Web, Python, Rust, Go, Flutter, C/C++, AI/ML).
  - revolt-dev create: Scaffolds clean, production-ready starter templates.
  - revolt-dev container: Manages isolated Distrobox / Podman development environments.
"""

import sys
import os
import subprocess
import shutil
import json
import argparse
from pathlib import Path
from typing import Dict, List, Tuple

PRESETS = {
    "web": {
        "name": "Web & Frontend Development",
        "packages": ["nodejs", "npm", "yarn", "ripgrep", "curl", "git"],
        "tools": ["node", "npm", "git"],
        "description": "JavaScript/TypeScript, Node.js, React, Vue, Next.js, and modern bundlers."
    },
    "fullstack": {
        "name": "Full-Stack Web Development",
        "packages": ["nodejs", "npm", "python3-venv", "sqlite3", "postgresql-client", "curl", "git"],
        "tools": ["node", "npm", "python3", "sqlite3", "git"],
        "description": "Full-stack application stack with Node, Python, SQLite, and client tools."
    },
    "python": {
        "name": "Python & Data Science",
        "packages": ["python3-dev", "python3-pip", "python3-venv", "build-essential", "libffi-dev"],
        "tools": ["python3", "pip3", "git"],
        "description": "Python 3 environment with venv, pip, and native compilation wheels."
    },
    "rust": {
        "name": "Rust Systems Engineering",
        "packages": ["build-essential", "gcc", "g++", "cmake", "libssl-dev", "pkg-config", "gdb"],
        "tools": ["gcc", "cargo", "rustc", "gdb"],
        "description": "High-performance systems programming with Rust, Cargo, and C compiler tooling."
    },
    "go": {
        "name": "Go Backend & Cloud Native",
        "packages": ["golang", "build-essential", "git", "curl"],
        "tools": ["go", "git"],
        "description": "Go runtime with module support for microservices and cloud tooling."
    },
    "cpp": {
        "name": "Modern C / C++ & Qt6",
        "packages": ["build-essential", "gcc", "g++", "gdb", "clang", "clang-format", "cmake", "ninja-build", "valgrind"],
        "tools": ["gcc", "g++", "cmake", "ninja", "clang", "gdb"],
        "description": "C++20/23 toolchain with CMake, Ninja, Clang-format, and Valgrind profiling."
    },
    "flutter": {
        "name": "Cross-Platform Flutter & Dart",
        "packages": ["curl", "git", "unzip", "xz-utils", "zip", "libglu1-mesa", "clang", "cmake", "ninja-build"],
        "tools": ["git", "cmake", "ninja", "clang"],
        "description": "Native dependencies for Flutter desktop and mobile development."
    },
    "ai": {
        "name": "Local & Cloud AI Engineering",
        "packages": ["python3-dev", "python3-pip", "python3-venv", "build-essential", "ocl-icd-libopencl1"],
        "tools": ["python3", "pip3", "git"],
        "description": "AI & ML stack supporting PyTorch, HuggingFace, Ollama, and local GGUF models."
    }
}


def check_tool(tool_name: str) -> Tuple[bool, str]:
    path = shutil.which(tool_name)
    if not path:
        return False, "Not Installed"
    try:
        res = subprocess.run([tool_name, "--version"], capture_output=True, text=True, timeout=2)
        out = (res.stdout or res.stderr or "").strip().split("\n")[0]
        return True, out[:45]
    except Exception:
        return True, path


def cmd_doctor(args):
    print("\n" + "=" * 60)
    print("      RevoltOS Developer Environment Diagnostics (Doctor)     ")
    print("=" * 60)

    categories = {
        "Compilers & Core Tools": ["gcc", "g++", "clang", "cmake", "ninja", "make", "gdb"],
        "Programming Languages": ["python3", "node", "cargo", "rustc", "go", "java"],
        "Version Control & Utilities": ["git", "curl", "ripgrep", "fzf", "bat", "jq"],
        "Container Environments": ["podman", "docker", "distrobox"],
        "Local AI Infrastructure": ["ollama", "llama-server"]
    }

    for cat_name, tools in categories.items():
        print(f"\n[+] {cat_name}:")
        for tool in tools:
            installed, info = check_tool(tool)
            badge = "[ OK ]" if installed else "[MISS]"
            print(f"  {badge} {tool:<14} : {info}")

    # Check Local Ollama Service
    print("\n[+] Local AI Status:")
    try:
        import urllib.request
        req = urllib.request.Request("http://127.0.0.1:11434/api/tags", headers={"User-Agent": "revolt-dev"})
        with urllib.request.urlopen(req, timeout=1.5) as resp:
            data = json.loads(resp.read().decode())
            models = [m.get("name") for m in data.get("models", [])]
            print(f"  [ OK ] Ollama Service  : Active at http://127.0.0.1:11434")
            print(f"         Loaded Models   : {', '.join(models) if models else 'None (run: ollama pull qwen2.5-coder:1.5b)'}")
    except Exception:
        print("  [INFO] Ollama Service  : Inactive or not running on port 11434.")
        print("         Tip: Start Ollama with 'ollama serve' or enable 'systemctl --user start revoltd'")

    print("\n" + "=" * 60 + "\n")


def cmd_preset_list(args):
    print("\nAvailable RevoltOS Developer Presets:")
    print("-" * 60)
    for p_id, p_info in PRESETS.items():
        print(f"  * {p_id:<10} : {p_info['name']}")
        print(f"                 {p_info['description']}")
    print("-" * 60)
    print("Install a preset with: revolt-dev preset install <preset-id>\n")


def cmd_preset_install(args):
    preset_id = args.preset.lower()
    if preset_id not in PRESETS:
        print(f"[-] Error: Unknown preset '{preset_id}'. Run 'revolt-dev preset list' to view available presets.")
        sys.exit(1)

    preset = PRESETS[preset_id]
    print(f"\n[*] Configuring RevoltOS Preset: {preset['name']}")
    print(f"    Required packages: {' '.join(preset['packages'])}")

    if os.geteuid() != 0:
        print("[!] Privilege escalation required to install system packages via APT.")
        cmd = ["sudo", "apt-get", "update"]
        subprocess.run(cmd)
        install_cmd = ["sudo", "apt-get", "install", "-y", "--no-install-recommends"] + preset["packages"]
        ret = subprocess.run(install_cmd)
    else:
        subprocess.run(["apt-get", "update"])
        ret = subprocess.run(["apt-get", "install", "-y", "--no-install-recommends"] + preset["packages"])

    if ret.returncode == 0:
        print(f"\n[+] SUCCESS: Preset '{preset_id}' installed successfully!")
        print("    Run 'revolt-dev doctor' to verify installed tools.")
    else:
        print(f"\n[-] Installation encountered errors. Exit code: {ret.returncode}")


def cmd_create(args):
    preset = args.preset.lower()
    name = args.name
    target_dir = Path(args.dest or ".").resolve() / name

    if target_dir.exists():
        print(f"[-] Error: Target directory '{target_dir}' already exists.")
        sys.exit(1)

    print(f"\n[*] Scaffolding starter project '{name}' with preset '{preset}'...")
    target_dir.mkdir(parents=True, exist_ok=True)

    gitignore = target_dir / ".gitignore"
    readme = target_dir / "README.md"
    readme.write_text(f"# {name}\n\nProject created with RevoltOS Developer Manager (`revolt-dev`).\nPreset: `{preset}`\n")

    if preset in ("web", "fullstack"):
        gitignore.write_text("node_modules/\n.env\ndist/\nbuild/\n*.log\n")
        pkg_json = target_dir / "package.json"
        pkg_json.write_text(json.dumps({
            "name": name,
            "version": "0.1.0",
            "type": "module",
            "scripts": {
                "dev": "vite",
                "build": "vite build"
            }
        }, indent=2))
        src_dir = target_dir / "src"
        src_dir.mkdir(exist_ok=True)
        (src_dir / "index.js").write_text("console.log('Welcome to RevoltOS Modern Web Stack!');\n")

    elif preset == "python":
        gitignore.write_text("__pycache__/\n*.py[cod]\n.venv/\nenv/\n*.log\n")
        (target_dir / "requirements.txt").write_text("pytest>=8.0.0\nhttpx>=0.27.0\n")
        (target_dir / "main.py").write_text(
            "def main():\n"
            "    print('Hello from RevoltOS Python project!')\n\n"
            "if __name__ == '__main__':\n"
            "    main()\n"
        )

    elif preset == "rust":
        if shutil.which("cargo"):
            subprocess.run(["cargo", "init", "--name", name, str(target_dir)])
        else:
            gitignore.write_text("target/\nCargo.lock\n")
            (target_dir / "Cargo.toml").write_text(f'[package]\nname = "{name}"\nversion = "0.1.0"\nedition = "2021"\n')
            src = target_dir / "src"
            src.mkdir(exist_ok=True)
            (src / "main.rs").write_text('fn main() {\n    println!("Hello from RevoltOS Rust!");\n}\n')

    elif preset == "go":
        gitignore.write_text("bin/\n*.exe\nvendor/\n")
        subprocess.run(["go", "mod", "init", name], cwd=str(target_dir))
        (target_dir / "main.go").write_text(
            'package main\n\nimport "fmt"\n\nfunc main() {\n\tfmt.Println("Hello from RevoltOS Go!")\n}\n'
        )

    elif preset == "cpp":
        gitignore.write_text("build/\n*.o\n*.a\nCMakeCache.txt\n")
        (target_dir / "CMakeLists.txt").write_text(
            f"cmake_minimum_required(VERSION 3.20)\nproject({name} CXX)\n\n"
            f"set(CMAKE_CXX_STANDARD 20)\nset(CMAKE_CXX_STANDARD_REQUIRED ON)\n\n"
            f"add_executable({name} src/main.cpp)\n"
        )
        src = target_dir / "src"
        src.mkdir(exist_ok=True)
        (src / "main.cpp").write_text(
            '#include <iostream>\n\nint main() {\n    std::cout << "Hello from RevoltOS C++20!" << std::endl;\n    return 0;\n}\n'
        )

    # Git initialization
    if shutil.which("git"):
        subprocess.run(["git", "init", "-q"], cwd=str(target_dir))

    print(f"[+] Project successfully created at: {target_dir}")
    print(f"    Get started:\n      cd {target_dir}\n")


def cmd_container(args):
    action = args.action
    has_distrobox = shutil.which("distrobox") is not None
    has_podman = shutil.which("podman") is not None
    has_docker = shutil.which("docker") is not None

    if not (has_distrobox or has_podman or has_docker):
        print("[-] Container tools not installed. Run 'sudo apt-get install distrobox podman' to enable.")
        sys.exit(1)

    if action == "list":
        if has_distrobox:
            subprocess.run(["distrobox", "list"])
        elif has_podman:
            subprocess.run(["podman", "ps", "-a"])
        else:
            subprocess.run(["docker", "ps", "-a"])

    elif action == "create":
        c_name = args.name or "revolt-sandbox"
        image = args.image or "archlinux:latest"
        print(f"[*] Creating isolated developer container '{c_name}' using image '{image}'...")
        if has_distrobox:
            subprocess.run(["distrobox", "create", "--name", c_name, "--image", image])
            print(f"[+] Container created. Enter with: revolt-dev container enter {c_name}")
        else:
            engine = "podman" if has_podman else "docker"
            subprocess.run([engine, "create", "-it", "--name", c_name, image])

    elif action == "enter":
        c_name = args.name or "revolt-sandbox"
        if has_distrobox:
            subprocess.run(["distrobox", "enter", c_name])
        else:
            engine = "podman" if has_podman else "docker"
            subprocess.run([engine, "start", "-ai", c_name])


def main():
    parser = argparse.ArgumentParser(
        prog="revolt-dev",
        description="RevoltOS Developer Environment Manager (One-click presets, diagnostics, and isolated containers)"
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    # Doctor
    sub_doc = subparsers.add_parser("doctor", help="Check compiler toolchains, runtimes, containers, and AI services")
    sub_doc.set_defaults(func=cmd_doctor)

    # Preset
    sub_pre = subparsers.add_parser("preset", help="Manage developer technology presets")
    pre_sub = sub_pre.add_subparsers(dest="preset_cmd", required=True)
    
    pre_list = pre_sub.add_parser("list", help="List available developer presets")
    pre_list.set_defaults(func=cmd_preset_list)
    
    pre_inst = pre_sub.add_parser("install", help="Install a developer preset")
    pre_inst.add_argument("preset", help="Preset identifier (e.g. web, python, rust, go, cpp, ai)")
    pre_inst.set_defaults(func=cmd_preset_install)

    # Create
    sub_create = subparsers.add_parser("create", help="Scaffold starter project templates")
    sub_create.add_argument("preset", help="Preset type (web, python, rust, go, cpp)")
    sub_create.add_argument("name", help="Project folder name")
    sub_create.add_argument("--dest", help="Destination parent directory (default: current directory)")
    sub_create.set_defaults(func=cmd_create)

    # Container
    sub_cont = subparsers.add_parser("container", help="Manage isolated Distrobox/Podman environments")
    sub_cont.add_argument("action", choices=["list", "create", "enter"], help="Container action")
    sub_cont.add_argument("name", nargs="?", default="revolt-sandbox", help="Container instance name")
    sub_cont.add_argument("--image", default="archlinux:latest", help="Container base image (default: archlinux:latest)")
    sub_cont.set_defaults(func=cmd_container)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
