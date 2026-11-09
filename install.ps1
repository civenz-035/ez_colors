# ============================================================
# install.ps1 — ez_colors Windows/PowerShell One-Line Installer
#
# Usage (One-liner for friends):
#   irm https://raw.githubusercontent.com/civenz-035/ez_colors/main/install.ps1 | iex
#
# Local install:
#   .\install.ps1
# ============================================================

& {
    $ErrorActionPreference = 'Stop'
    try {
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    } catch {}

    $RepoRawBase = "https://raw.githubusercontent.com/civenz-035/ez_colors/main"
    $ModuleName  = "ez_colors"

    Write-Host "===================================================" -ForegroundColor Cyan
    Write-Host "  Installing ez_colors for PowerShell..." -ForegroundColor Yellow
    Write-Host "===================================================" -ForegroundColor Cyan

    # Determine module target paths for both PowerShell 7+ and Windows PowerShell 5.1
    $TargetDirs = @()

    $DocsPath = [Environment]::GetFolderPath('MyDocuments')
    if ($DocsPath) {
        $TargetDirs += Join-Path $DocsPath "PowerShell\Modules\$ModuleName"
        $TargetDirs += Join-Path $DocsPath "WindowsPowerShell\Modules\$ModuleName"
    }

    # Fallback: $HOME/.local/share/powershell/Modules on Unix
    if ($PSVersionTable.Platform -eq 'Unix') {
        $TargetDirs = @(Join-Path $HOME ".local/share/powershell/Modules/$ModuleName")
    }

    # Find source files (Local clone vs Remote download)
    $ScriptDir = ""
    try {
        if ($PSScriptRoot) { $ScriptDir = $PSScriptRoot }
    } catch {}

    foreach ($target in $TargetDirs) {
        if (-not (Test-Path $target)) {
            New-Item -ItemType Directory -Path $target -Force | Out-Null
        }

        if ($ScriptDir -and (Test-Path (Join-Path $ScriptDir "ez_colors.psm1"))) {
            Write-Host "  ↳ Copying module from local files ($ScriptDir) -> $target" -ForegroundColor Gray
            Copy-Item (Join-Path $ScriptDir "ez_colors.psm1") (Join-Path $target "ez_colors.psm1") -Force
            Copy-Item (Join-Path $ScriptDir "ez_colors.psd1") (Join-Path $target "ez_colors.psd1") -Force
        } else {
            Write-Host "  ↳ Downloading module from GitHub -> $target" -ForegroundColor Gray
            Invoke-RestMethod -Uri "$RepoRawBase/ez_colors.psm1" -OutFile (Join-Path $target "ez_colors.psm1")
            Invoke-RestMethod -Uri "$RepoRawBase/ez_colors.psd1" -OutFile (Join-Path $target "ez_colors.psd1")
        }
    }

    # Add Import-Module to $PROFILE
    $ProfilePaths = @($PROFILE.CurrentUserCurrentHost, $PROFILE.CurrentUserAllHosts) | Select-Object -Unique
    foreach ($prof in $ProfilePaths) {
        if (-not $prof) { continue }
        $profDir = Split-Path $prof
        if (-not (Test-Path $profDir)) {
            New-Item -ItemType Directory -Path $profDir -Force | Out-Null
        }
        if (-not (Test-Path $prof)) {
            New-Item -ItemType File -Path $prof -Force | Out-Null
        }

        $marker = "# ez_colors"
        $importCmd = "Import-Module $ModuleName -ErrorAction SilentlyContinue"
        $content = Get-Content $prof -Raw -ErrorAction SilentlyContinue

        if (-not $content -or $content -notmatch [regex]::Escape($marker)) {
            Add-Content -Path $prof -Value "`n$marker`n$importCmd`n"
            Write-Host "  ↳ Added auto-import to $prof" -ForegroundColor Green
        } else {
            Write-Host "  ↳ Already configured in $prof" -ForegroundColor DarkGray
        }
    }

    # Import immediately into the current active session
    try {
        Import-Module $ModuleName -Force
    } catch {
        $firstTarget = $TargetDirs[0]
        Import-Module (Join-Path $firstTarget "ez_colors.psd1") -Force
    }

    Write-Host ""
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host "  ez_colors installed successfully!" -ForegroundColor Green
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Try running these commands right now:" -ForegroundColor Yellow
    Write-Host "  cn 208 b 'Hello from ez_colors!'" -ForegroundColor Cyan
    Write-Host "  mc 'Rainbow colors work in PowerShell!'" -ForegroundColor Cyan
    Write-Host "  _ok 'Everything is ready!'" -ForegroundColor Cyan
    Write-Host ""
}
