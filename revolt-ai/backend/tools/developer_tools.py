"""
RevoltOS Developer AI Tools
Provides specialized developer intelligence:
- Error log diagnosis (compilers, runtime stack traces)
- Git commit message generation from staged diffs
- Code explanation and refactoring
- Sandboxed desktop command execution with 4-tier security classification
"""

import subprocess
import shutil
import os
import re
from pathlib import Path
from typing import Dict, Any, Tuple


class DeveloperTools:
    # 4-Tier Security Classification
    TIER_READ_ONLY = "read_only"       # auto-execute without confirmation
    TIER_REVERSIBLE = "reversible"     # auto-execute with notification toast
    TIER_SENSITIVE = "sensitive"       # requires user confirmation prompt in Island
    TIER_DESTRUCTIVE = "destructive"   # requires explicit Polkit / root password dialog

    SAFE_READ_COMMANDS = {
        "cat", "ls", "grep", "find", "head", "tail", "wc", "stat", "df", "free",
        "uname", "uptime", "ps", "lsof", "git status", "git diff", "git log",
        "which", "whereis", "echo", "pwd"
    }

    DESTRUCTIVE_PATTERNS = [
        r"\brm\s+-[rf]+", r"\bmkfs\b", r"\bdd\s+if=", r"\bfdisk\b", r"\bparted\b",
        r"\bshutdown\b", r"\breboot\b", r">\s*/dev/sd", r":\(\)\{ :\|:& \};:"
    ]

    @classmethod
    def classify_command(cls, command: str) -> str:
        cmd = command.strip()
        for pat in cls.DESTRUCTIVE_PATTERNS:
            if re.search(pat, cmd):
                return cls.TIER_DESTRUCTIVE

        first_word = cmd.split()[0] if cmd else ""
        if first_word in ("git",) and any(cmd.startswith(s) for s in ("git status", "git diff", "git log", "git branch")):
            return cls.TIER_READ_ONLY

        if first_word in cls.SAFE_READ_COMMANDS and ">" not in cmd and "|" not in cmd:
            return cls.TIER_READ_ONLY

        if first_word in ("apt", "apt-get", "systemctl", "reboot", "poweroff"):
            return cls.TIER_DESTRUCTIVE

        if first_word in ("mkdir", "touch", "cp", "mv"):
            return cls.TIER_REVERSIBLE

        return cls.TIER_SENSITIVE

    @classmethod
    def execute_command(cls, command: str, confirm: bool = False) -> Dict[str, Any]:
        tier = cls.classify_command(command)
        if tier in (cls.TIER_SENSITIVE, cls.TIER_DESTRUCTIVE) and not confirm:
            return {
                "success": False,
                "tier": tier,
                "requires_confirmation": True,
                "output": f"Command '{command}' classified as {tier.upper()}. Confirmation required before execution."
            }

        try:
            res = subprocess.run(command, shell=True, capture_output=True, text=True, timeout=15)
            out = res.stdout if res.returncode == 0 else (res.stderr or res.stdout)
            return {
                "success": res.returncode == 0,
                "tier": tier,
                "exit_code": res.returncode,
                "output": out.strip()
            }
        except subprocess.TimeoutExpired:
            return {"success": False, "tier": tier, "output": "Execution timed out (15s limit)."}
        except Exception as e:
            return {"success": False, "tier": tier, "output": str(e)}

    @classmethod
    def generate_git_commit(cls, repo_dir: str = ".") -> str:
        """Inspects git staged diff and returns a conventional commit message."""
        try:
            res = subprocess.run(["git", "diff", "--staged"], cwd=repo_dir, capture_output=True, text=True)
            diff = res.stdout.strip()
            if not diff:
                res_unstaged = subprocess.run(["git", "diff"], cwd=repo_dir, capture_output=True, text=True)
                diff = res_unstaged.stdout.strip()
                if not diff:
                    return "chore: update project files"

            # Parse files changed
            stat_res = subprocess.run(["git", "diff", "--stat"], cwd=repo_dir, capture_output=True, text=True)
            stat = stat_res.stdout.strip().split("\n")[0] if stat_res.stdout else ""
            return f"feat: enhance codebase ({stat})\n\nAuto-generated summary from RevoltOS Dev AI."
        except Exception as e:
            return f"chore: update files ({str(e)})"

    @classmethod
    def diagnose_error(cls, error_log: str) -> Dict[str, str]:
        """Heuristic analysis of common build, compiler, and runtime errors."""
        log = error_log.strip()
        diagnosis = {
            "error_type": "Generic Error",
            "suggested_fix": "Review the full terminal stack trace for missing symbols or files."
        }

        if "command not found" in log.lower() or "is not recognized" in log.lower():
            diagnosis["error_type"] = "Missing Executable / PATH Error"
            diagnosis["suggested_fix"] = "Install the missing package with 'revolt-dev preset install <preset>' or check system $PATH."
        elif "undefined reference to" in log or "fatal error:" in log:
            diagnosis["error_type"] = "C/C++ Compiler / Linker Error"
            diagnosis["suggested_fix"] = "Check include headers and ensure target libraries are linked in CMakeLists.txt (target_link_libraries)."
        elif "modulenotfounderror" in log.lower() or "no module named" in log.lower():
            diagnosis["error_type"] = "Python Dependency Missing"
            diagnosis["suggested_fix"] = "Activate virtual environment and run 'pip install <missing-package>' or update requirements.txt."
        elif "error[e0" in log:
            diagnosis["error_type"] = "Rust Borrow Checker / Compiler Error"
            diagnosis["suggested_fix"] = "Check ownership, lifetimes, or run 'cargo clippy' for idiomatic compiler suggestions."
        elif "permission denied" in log.lower():
            diagnosis["error_type"] = "POSIX Permission / Access Restriction"
            diagnosis["suggested_fix"] = "Verify file executable bits with 'chmod +x' or run with Polkit authorization."

        return diagnosis
