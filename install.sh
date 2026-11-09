#!/usr/bin/env bash
# ============================================================
# install.sh — bash-colors installer
#
# Supports both:
#   1. Remote one-liner (curl | bash):
#      curl -fsSL https://raw.githubusercontent.com/civenz-035/bash-colors/main/install.sh | bash -s -- --rc
#
#   2. Local clone:
#      git clone https://github.com/civenz-035/bash-colors.git
#      cd bash-colors && bash install.sh --rc
#
# Options:
#   --prefix <dir>   Install directory (default: ~/.bash-colors)
#   --bashrc         Auto-append source line to ~/.bashrc
#   --zshrc          Auto-append source line to ~/.zshrc
#   --rc             Auto-append to both ~/.bashrc and ~/.zshrc (Recommended)
# ============================================================
set -euo pipefail

REPO_URL="https://github.com/civenz-035/bash-colors.git"
RAW_BASE_URL="https://raw.githubusercontent.com/civenz-035/bash-colors/main"
PREFIX="${HOME}/.bash-colors"
ADD_BASHRC=0
ADD_ZSHRC=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --prefix)   PREFIX="$2"; shift 2 ;;
        --bashrc)   ADD_BASHRC=1; shift ;;
        --zshrc)    ADD_ZSHRC=1;  shift ;;
        --rc)       ADD_BASHRC=1; ADD_ZSHRC=1; shift ;;
        -h|--help)
            echo "Usage: bash install.sh [--prefix <dir>] [--bashrc] [--zshrc] [--rc]"
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

# If piped without arguments, default to --rc so friends have zero friction
if (( ADD_BASHRC == 0 && ADD_ZSHRC == 0 )) && [ ! -t 0 ]; then
    ADD_BASHRC=1
    ADD_ZSHRC=1
fi

echo "==================================================="
echo "  Installing bash-colors to: $PREFIX"
echo "==================================================="

mkdir -p "$PREFIX/lib"

# Determine source location: local vs remote pipe
SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" ]] && [[ -f "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [[ -n "$SCRIPT_DIR" ]] && [[ -f "$SCRIPT_DIR/colors.sh" ]]; then
    echo "  ↳ Installing from local files ($SCRIPT_DIR)..."
    cp "$SCRIPT_DIR/colors.sh"    "$PREFIX/colors.sh"
    cp "$SCRIPT_DIR/lib/"*.sh     "$PREFIX/lib/"
else
    echo "  ↳ Installing via remote download from GitHub ($REPO_URL)..."
    if command -v git >/dev/null 2>&1; then
        TEMP_DIR="$(mktemp -d)"
        git clone --depth=1 "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1
        cp "$TEMP_DIR/colors.sh"    "$PREFIX/colors.sh"
        cp "$TEMP_DIR/lib/"*.sh     "$PREFIX/lib/"
        rm -rf "$TEMP_DIR"
    else
        # Fallback to curl
        echo "    Downloading modules via curl..."
        curl -fsSL "$RAW_BASE_URL/colors.sh" -o "$PREFIX/colors.sh"
        MODULES=(
            "00-escapes.sh"
            "01-palette.sh"
            "02-render.sh"
            "03-rainbow.sh"
            "04-random.sh"
            "05-rcc.sh"
            "06-table.sh"
            "07-utils.sh"
        )
        for mod in "${MODULES[@]}"; do
            curl -fsSL "$RAW_BASE_URL/lib/$mod" -o "$PREFIX/lib/$mod"
        done
    fi
fi

chmod +x "$PREFIX/colors.sh"

SOURCE_LINE="source \"$PREFIX/colors.sh\""
MARKER="# bash-colors"

_append_to_rc() {
    local rcfile="$1"
    if [[ ! -f "$rcfile" ]]; then
        touch "$rcfile"
    fi
    if grep -qF "$MARKER" "$rcfile" 2>/dev/null; then
        echo "  ↳ $rcfile — already configured, skipping."
    else
        printf '\n%s\n%s\n' "$MARKER" "$SOURCE_LINE" >> "$rcfile"
        echo "  ↳ $rcfile — source line added."
    fi
}

(( ADD_BASHRC )) && _append_to_rc "$HOME/.bashrc"
(( ADD_ZSHRC  )) && _append_to_rc "$HOME/.zshrc"

echo ""
echo "✅ bash-colors successfully installed!"
echo ""
echo "Quick Start:"
echo "  1. Reload your shell:  source \"$PREFIX/colors.sh\""
echo "  2. Test a color:       cn 208 b \"Hello bash-colors!\""
echo "  3. Test rainbow:       mc \"Rainbow text works!\""
