#!/usr/bin/env bash
# ============================================================
# demo.sh — Visual Feature Showcase for ez_colors
# Run: bash demo.sh
# ============================================================
_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$_DIR/colors.sh"

clear 2>/dev/null || true

# 1. Header Box
box_card --border 82 \
    "$(mc -b "🎨 ez_colors — Feature Showcase")" \
    "---" \
    "Zero-dependency modular Bash/Zsh color engine" \
    "Version 3.0.0 | GitHub: civenz-035/ez_colors"

echo ""

# 2. Core Render
cn 208 b "▶ 1. Basic & Short-name Colors"
hline 50 240
c 82 "  green " ; c 226 "yellow " ; c 45 "cyan " ; c 196 "red " ; cn 208 "orange"
c r "  [r] "   ; c g " [g] "    ; c y " [y] "  ; c cr " [cr] " ; cn m " [m]"
echo ""

# 3. Status Helpers
cn 208 b "▶ 2. Status Notifications"
hline 50 240
  _sc   "  Task completed successfully"
  _warn "  Configuration file warning"
  _er   "  Connection failed"
  _ep   "  Verbose operational notice"
echo ""

# 4. Gradients & Rainbow
cn 208 b "▶ 3. Gradients & Rainbow Spectrum"
hline 50 240
printf "  Default : " ; mc "The quick brown fox jumps over the lazy dog"
printf "  Blue    : " ; mc -b "Deep navy to bright cyan gradient"
printf "  Pink    : " ; mc -pk b "Hot pink and plum bold gradient"
printf "  Fire    : " ; rainbow_palette --fire "Fiery flame burn progression"
printf "  Ice     : " ; rainbow_palette --ice "Cool arctic glacier breeze"
echo ""

# 5. Random Color Engine (Stateful)
cn 208 b "▶ 4. Random Color Engine (Slot-based)"
hline 50 240
printf "  Vibrant (rc)  : " ; rc "Random 12-color vibrant spectrum"
printf "  Pastel (rc1)  : " ; rc1 "Soft pastel aesthetic palette"
printf "  Neon (rc2)    : " ; rc2 b "High contrast neon punch"
printf "  Pinned slot   : " ; rc -s demo_slot "Slot color part A"; rc -s demo_slot " | Slot color part B (Identical!)"
echo ""

# 6. Random Per-Character
cn 208 b "▶ 5. Random Per-Character Styling"
hline 50 240
printf "  Vibrant : " ; rcc "Every character has an alternating vibrant color!"
printf "  Pastel  : " ; rcc1 b "Soft pastel alternating bold letters"
echo ""

# 7. Tables & Layout
cn 208 b "▶ 6. Structured Tabular Output (ctab)"
hline 50 240
ctab "b82:18 b226:22 b45:0" "Command" "Argument" "Description"
hline 50 242 "─"
ctab "46:18 244:22 250:0" "c <color>" "[style] <text>" "Inline print (no newline)"
ctab "46:18 244:22 250:0" "cn <color>" "[style] <text>" "Line print (with newline)"
ctab "46:18 244:22 250:0" "mc [flags]" "<text>" "Full gradient / rainbow"
ctab "46:18 244:22 250:0" "box_card" "\"line1\" \"---\"" "Auto-scaled Unicode card"
echo ""

# 8. Background Color Preservation
cn 208 b "▶ 7. Background Color Engine (cbg)"
hline 50 240
printf "  " ; cbgl 22 "  Dark green background with preserved foreground  "
printf "  " ; cbgl 53 "  Dark purple background with preserved foreground  "
echo ""

box_card --border 208 \
    "$(cn 226 b "Ready to share with your friends!")" \
    "---" \
    "curl -fsSL https://raw.githubusercontent.com/civenz-035/ez_colors/main/install.sh | bash -s -- --rc"

echo ""
