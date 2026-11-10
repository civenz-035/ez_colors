# ============================================================
# test.ps1 — QA Unit Test for ez_colors PowerShell Module
# ============================================================
$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$Pass = 0
$Fail = 0

function Assert-Test([string]$Name, [scriptblock]$Action) {
    try {
        & $Action | Out-Null
        Write-Host "✅ PASS: $Name" -ForegroundColor Green
        $script:Pass++
    } catch {
        Write-Host "❌ FAIL: $Name -> $_" -ForegroundColor Red
        $script:Fail++
    }
}

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "  ez_colors — PowerShell QA Smoke Test" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

# 1. Import module
Assert-Test "Import-Module ez_colors.psd1" {
    Import-Module (Join-Path $ScriptDir "ez_colors.psd1") -Force
}

# 2. Test core render
Assert-Test "c and cn functions exist" {
    Get-Command c, cn | Out-Null
}

Assert-Test "cn 208 b renders" {
    cn 208 b "orange bold text"
}

Assert-Test "c r short-name renders" {
    c r "red inline "
    cn g "green"
}

# 3. Test rainbow and gradients
Assert-Test "mc rainbow renders" {
    mc "Rainbow test in PowerShell"
}

Assert-Test "mc -b blue gradient renders" {
    mc -b "Blue gradient"
}

Assert-Test "mc --fire renders" {
    mc --fire "Fire gradient"
}

# 4. Test random colors
Assert-Test "rc random vibrant renders" {
    rc "random vibrant"
}

Assert-Test "rc1 random pastel renders" {
    rc1 "random pastel"
}

Assert-Test "rc2 random neon renders" {
    rc2 "random neon"
}

# 5. Test per-char colors
Assert-Test "rcc per-char renders" {
    rcc "Per-character colors in PowerShell"
}

# 6. Test status helpers
Assert-Test "_sc, _warn, _er, _ep status helpers" {
    _sc "Success status"
    _warn "Warning status"
    _er "Error status"
    _ep "Explain status"
}

# 7. Test table and card
Assert-Test "ctab renders" {
    ctab "b82:15 244:20" "Cmd" "Description"
}

Assert-Test "box_card renders" {
    box_card "PowerShell Card" "---" "Lines look great" --Border 82
}

Write-Host ""
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "  Results: $Pass passed, $Fail failed" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

if ($Fail -eq 0) {
    Write-Host "🎉 ALL POWERSHELL TESTS PASSED" -ForegroundColor Green
    exit 0
} else {
    Write-Host "❌ SOME TESTS FAILED" -ForegroundColor Red
    exit 1
}

