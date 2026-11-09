#!/usr/bin/env bash
# ============================================================
# 01-colors.sh — Backward Compatibility Shim
# Loads the modular bash-colors toolkit (colors.sh)
# ============================================================
_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$_DIR/colors.sh"
unset _DIR
