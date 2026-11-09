#!/usr/bin/env bash
# ============================================================
# uninstall.sh — bash-colors uninstaller
# Usage:  bash uninstall.sh [--prefix <dir>]
# ============================================================
set -euo pipefail

PREFIX="${HOME}/.bash-colors"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --prefix) PREFIX="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

MARKER="# bash-colors"

if [[ -d "$PREFIX" ]]; then
    rm -rf "$PREFIX"
    echo "✅ Removed $PREFIX"
else
    echo "⚠  $PREFIX not found — nothing to remove."
fi

_remove_from_rc() {
    local rcfile="$1"
    if [[ -f "$rcfile" ]] && grep -qF "$MARKER" "$rcfile"; then
        # Remove the marker line and the source line following it
        sed -i.bak "/$MARKER/,+1d" "$rcfile"
        echo "  ↳ $rcfile — source line removed."
    fi
}

_remove_from_rc "$HOME/.bashrc"
_remove_from_rc "$HOME/.zshrc"

echo "Done. Restart your shell to deactivate."

