# ============================================================
# uninstall.ps1 — ez_colors Windows/PowerShell Uninstaller
# ============================================================
$ModuleName = "ez_colors"

Write-Host "Uninstalling $ModuleName..." -ForegroundColor Yellow

# Remove from module folders
$DocsPath = [Environment]::GetFolderPath('MyDocuments')
$TargetDirs = @()
if ($DocsPath) {
    $TargetDirs += Join-Path $DocsPath "PowerShell\Modules\$ModuleName"
    $TargetDirs += Join-Path $DocsPath "WindowsPowerShell\Modules\$ModuleName"
}

foreach ($target in $TargetDirs) {
    if (Test-Path $target) {
        Remove-Item -Path $target -Recurse -Force
        Write-Host "  ↳ Removed $target" -ForegroundColor Green
    }
}

# Clean profile
$ProfilePaths = @($PROFILE.CurrentUserCurrentHost, $PROFILE.CurrentUserAllHosts) | Select-Object -Unique
$marker = "# ez_colors"

foreach ($prof in $ProfilePaths) {
    if ($prof -and (Test-Path $prof)) {
        $lines = Get-Content $prof
        $newLines = @()
        $skipNext = $false
        foreach ($line in $lines) {
            if ($line -match [regex]::Escape($marker)) {
                $skipNext = $true
                continue
            }
            if ($skipNext -and $line -match 'Import-Module ez_colors') {
                $skipNext = $false
                continue
            }
            $skipNext = $false
            $newLines += $line
        }
        $newLines | Set-Content $prof
        Write-Host "  ↳ Cleaned $prof" -ForegroundColor Green
    }
}

Write-Host "$ModuleName uninstalled. Restart your PowerShell session." -ForegroundColor Yellow
