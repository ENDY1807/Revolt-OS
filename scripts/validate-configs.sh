#!/usr/bin/env bash
# ==============================================================================
# RevoltOS Static Configuration & Syntax Validator
# Verifies shell scripts, JSON configurations, package lists, and rules
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
ERRORS=0

echo "=================================================="
echo "    RevoltOS Configuration & Syntax Validator     "
echo "=================================================="

# 1. Validate Shell Scripts
echo "[*] Checking shell script syntax..."
while IFS= read -r script; do
    if ! bash -n "$script"; then
        echo "[-] Syntax error in: $script"
        ERRORS=$((ERRORS + 1))
    else
        echo "  [OK] $script"
    fi
done < <(find "$ROOT_DIR/scripts" "$ROOT_DIR/distro/live-build" -type f -name "*.sh" -o -name "*.hook.chroot")

# 2. Validate JSON / JSONC Configurations
echo "[*] Checking JSON / JSONC files..."
while IFS= read -r jsonfile; do
    if command -v node >/dev/null 2>&1; then
        # Node strip comments and parse test
        if ! node -e "
            const fs = require('fs');
            const content = fs.readFileSync(process.argv[1], 'utf8')
                .replace(/\/\/.*$/gm, '')
                .replace(/\/\*[\s\S]*?\*\//g, '');
            try {
                JSON.parse(content);
                process.exit(0);
            } catch(e) {
                console.error(e.message);
                process.exit(1);
            }
        " "$jsonfile"; then
            echo "[-] Invalid JSON in: $jsonfile"
            ERRORS=$((ERRORS + 1))
        else
            echo "  [OK] $jsonfile"
        fi
    fi
done < <(find "$ROOT_DIR/desktop" -type f -name "*.json" -o -name "*.jsonc")

# 3. Validate Package Lists
echo "[*] Checking Debian live-build package lists..."
while IFS= read -r pkglist; do
    # Verify no empty non-comment lines and check for duplicate package entries
    DUPES=$(grep -v '^#' "$pkglist" | grep -v '^[[:space:]]*$' | sort | uniq -d || true)
    if [ -n "$DUPES" ]; then
        echo "[-] Warning: Duplicate packages found in $pkglist:"
        echo "$DUPES"
        ERRORS=$((ERRORS + 1))
    else
        PKG_COUNT=$(grep -v '^#' "$pkglist" | grep -v '^[[:space:]]*$' | wc -l)
        echo "  [OK] $pkglist ($PKG_COUNT packages)"
    fi
done < <(find "$ROOT_DIR/distro/live-build/config/package-lists" -type f -name "*.list.chroot")

# 4. Summary
echo "=================================================="
if [ "$ERRORS" -eq 0 ]; then
    echo "[+] All RevoltOS configuration files passed validation!"
    exit 0
else
    echo "[-] Verification failed with $ERRORS error(s)."
    exit 1
fi
