# ============================================================
# demo.ps1 — Visual Feature Showcase for ez_colors (PowerShell)
# Run: pwsh demo.ps1
# ============================================================
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module (Join-Path $ScriptDir "ez_colors.psd1") -Force

Clear-Host

# 1. Header Box
box_card -Border 82 `
    "$(mc -b '🎨 ez_colors — PowerShell Feature Showcase')" `
    "---" `
    "Zero-dependency modular Cross-Platform color engine" `
    "Version 3.0.0 | GitHub: civenz-035/ez_colors"

Write-Host ""

# 2. Core Render
cn 208 b "▶ 1. Basic & Short-name Colors"
hline 50 240
c 82 "  green " ; c 226 "yellow " ; c 45 "cyan " ; c 196 "red " ; cn 208 "orange"
c r "  [r] "   ; c g " [g] "    ; c y " [y] "  ; c cr " [cr] " ; cn m " [m]"
Write-Host ""

# 3. Status Helpers
cn 208 b "▶ 2. Status Notifications"
hline 50 240
  _sc   "  Task completed successfully"
  _warn "  Configuration file warning"
  _er   "  Connection failed"
  _ep   "  Verbose operational notice"
Write-Host ""

# 4. Gradients & Rainbow
cn 208 b "▶ 3. Gradients & Rainbow Spectrum"
hline 50 240
[Console]::Write("  Default : ") ; mc "The quick brown fox jumps over the lazy dog"
[Console]::Write("  Blue    : ") ; mc -b "Deep navy to bright cyan gradient"
[Console]::Write("  Pink    : ") ; mc -pk b "Hot pink and plum bold gradient"
[Console]::Write("  Fire    : ") ; mc --fire "Fiery flame burn progression"
[Console]::Write("  Ice     : ") ; mc --ice "Cool arctic glacier breeze"
Write-Host ""

# 5. Random Color Engine (Stateful)
cn 208 b "▶ 4. Random Color Engine (Slot-based)"
hline 50 240
[Console]::Write("  Vibrant (rc)  : ") ; rc "Random 12-color vibrant spectrum"
[Console]::Write("  Pastel (rc1)  : ") ; rc1 "Soft pastel aesthetic palette"
[Console]::Write("  Neon (rc2)    : ") ; rc2 b "High contrast neon punch"
[Console]::Write("  Pinned slot   : ") ; rc -Slot "demo_slot" "Slot color part A"; rc -Slot "demo_slot" " | Slot color part B (Identical!)"
Write-Host ""

# 6. Random Per-Character
cn 208 b "▶ 5. Random Per-Character Styling"
hline 50 240
[Console]::Write("  Vibrant : ") ; rcc "Every character has an alternating vibrant color!"
[Console]::Write("  Pastel  : ") ; rcc1 b "Soft pastel alternating bold letters"
Write-Host ""

# 7. Tables & Layout
cn 208 b "▶ 6. Structured Tabular Output (ctab)"
hline 50 240
ctab "b82:18 b226:22 b45:0" "Command" "Argument" "Description"
hline 50 242 "─"
ctab "46:18 244:22 250:0" "c <color>" "[style] <text>" "Inline print (no newline)"
ctab "46:18 244:22 250:0" "cn <color>" "[style] <text>" "Line print (with newline)"
ctab "46:18 244:22 250:0" "mc [flags]" "<text>" "Full gradient / rainbow"
ctab "46:18 244:22 250:0" "box_card" "`"line1`" `"---`"" "Auto-scaled Unicode card"
Write-Host ""

# 8. Background Color Preservation
cn 208 b "▶ 7. Background Color Engine (cbg)"
hline 50 240
[Console]::Write("  ") ; cbgl 22 "  Dark green background with preserved foreground  "
[Console]::Write("  ") ; cbgl 53 "  Dark purple background with preserved foreground  "
Write-Host ""

box_card -Border 208 `
    "$(cn 226 b 'Ready to share with your friends on Windows!')" `
    "---" `
    "irm https://raw.githubusercontent.com/civenz-035/ez_colors/main/install.ps1 | iex"

Write-Host ""

