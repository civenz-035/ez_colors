# ============================================================
# ez_colors.psm1 — PowerShell Color Engine (Dual-Engine for Windows)
# Zero-dependency, compatible with Windows PowerShell 5.1 & PowerShell 7+
# ============================================================

# Ensure ANSI escape sequences are enabled in Windows Console
if ([System.Environment]::OSVersion.Platform -eq 'Win32NT') {
    try {
        $null = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    } catch {}
}

$script:ESC       = [char]27
$script:RST       = "$script:ESC[0m"
$script:BOLD      = "$script:ESC[1m"
$script:DIM       = "$script:ESC[2m"
$script:ITALIC    = "$script:ESC[3m"
$script:UNDERLINE = "$script:ESC[4m"
$script:RESET_BG  = "$script:ESC[49m"
$script:RESET_FG  = "$script:ESC[39m"

# ============================================================
# 1. Low-Level ANSI Escapes
# ============================================================
function script:Get-Fg([int]$num) { "$script:ESC[38;5;${num}m" }
function script:Get-Bg([int]$num) { "$script:ESC[48;5;${num}m" }

# ============================================================
# 2. Palette Definitions
# ============================================================
$script:RC_PALETTES = @{
    'default' = @(45, 82, 190, 196, 208, 201, 39, 226, 129, 48, 203, 141)
    'pastel'  = @(167, 173, 136, 71, 68, 105, 132, 178, 150, 139, 174, 180)
    'neon'    = @(21, 10, 196, 200, 225, 27, 202, 123, 229, 205)
    'dim'     = @(53, 22, 23, 17, 54, 58, 236, 64, 61)
    'fire'    = @(52, 88, 124, 160, 196, 202, 208, 214, 220, 226)
    'ice'     = @(17, 18, 19, 21, 27, 33, 39, 45, 51, 87, 123, 159, 231, 255)
    'blue'    = @(17, 18, 19, 20, 21, 27, 33, 39, 45, 51, 87, 123, 159)
    'cyan'    = @(23, 24, 30, 31, 37, 38, 44, 45, 50, 51, 86, 87, 122, 123, 159)
    'green'   = @(22, 28, 34, 40, 46, 82, 83, 118, 119, 154, 155, 190, 191)
    'red'     = @(52, 88, 124, 160, 196, 202, 203, 209, 210, 216, 217, 223)
    'pink'    = @(53, 89, 125, 161, 197, 198, 199, 205, 206, 212, 218, 224, 225)
    'sunset'  = @(53, 54, 93, 129, 161, 197, 202, 208, 214, 220, 226)
}

$script:NAMED_COLORS = @{
    'r'   = 196; 'lr'  = 203
    'g'   = 82;  'lg'  = 46
    'y'   = 226
    'cr'  = 51;  'lc'  = 87; 'lcr' = 87
    'b'   = 33;  'lb'  = 75
    'm'   = 141; 'lm'  = 141
    'w'   = 255; 'gr'  = 244
    'ora' = 208
}

$script:STATEFUL_SLOTS = @{}
$script:LAST_COLOR = $null

# ============================================================
# 3. Core Color Render Engine
# ============================================================
function script:Resolve-ColorCode([string]$color) {
    if ($color -match '^[0-9]+$') {
        return [int]$color
    }
    if ($script:NAMED_COLORS.ContainsKey($color.ToLower())) {
        return $script:NAMED_COLORS[$color.ToLower()]
    }
    if ($color -in @('rc', 'rand')) {
        return Get-Random -InputObject $script:RC_PALETTES['default']
    }
    if ($color -in @('rc1', 'rand1')) {
        return Get-Random -InputObject $script:RC_PALETTES['pastel']
    }
    if ($color -in @('rc2', 'rand2')) {
        return Get-Random -InputObject $script:RC_PALETTES['neon']
    }
    if ($color -in @('rc3', 'rand3', 'rc4', 'rand4')) {
        return Get-Random -InputObject $script:RC_PALETTES['dim']
    }
    return $null
}

function script:Build-StyleEscape([string]$style) {
    $st = ""
    if ($style -match '^[bdiu]+$') {
        foreach ($ch in $style.ToCharArray()) {
            switch ($ch) {
                'b' { $st += $script:BOLD }
                'd' { $st += $script:DIM }
                'i' { $st += $script:ITALIC }
                'u' { $st += $script:UNDERLINE }
            }
        }
    }
    return $st
}

function script:Render-Text($Color, $StyleOrText, [string[]]$Remaining) {
    $colorVal = script:Resolve-ColorCode "$Color"
    $styleEsc = ""
    $textParts = @()

    if ($null -ne $StyleOrText -and "$StyleOrText" -match '^[bdiu]{1,4}$') {
        $styleEsc = script:Build-StyleEscape "$StyleOrText"
        $textParts = $Remaining
    } else {
        if ($null -ne $StyleOrText) { $textParts += "$StyleOrText" }
        if ($Remaining.Count -gt 0)  { $textParts += $Remaining }
    }

    $finalText = $textParts -join ' '
    $escColor = if ($null -ne $colorVal) { script:Get-Fg $colorVal } else { "" }
    return "${escColor}${styleEsc}${finalText}$script:RST"
}

# c: Print without newline (for inline chaining)
function c {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Color,
        [Parameter(Position=1)]
        [string]$StyleOrText,
        [Parameter(Position=2, ValueFromRemainingArguments=$true)]
        [string[]]$Text
    )
    $output = script:Render-Text $Color $StyleOrText $Text
    [Console]::Write($output)
}

# cn: Print with newline
function cn {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Color,
        [Parameter(Position=1)]
        [string]$StyleOrText,
        [Parameter(Position=2, ValueFromRemainingArguments=$true)]
        [string[]]$Text
    )
    $output = script:Render-Text $Color $StyleOrText $Text
    [Console]::WriteLine($output)
}

function color { cn @args }

# Background-only color helper
function cbg {
    param(
        [Parameter(Mandatory=$true, Position=0)]$BgColor,
        [Parameter(Position=1, ValueFromRemainingArguments=$true)][string[]]$Text,
        [switch]$Newline
    )
    $bgCode = script:Resolve-ColorCode "$BgColor"
    if ($null -eq $bgCode) { $bgCode = 240 }
    $str = $Text -join ' '
    $bgEsc = script:Get-Bg $bgCode
    $out = "${bgEsc}${str}$script:RESET_BG"
    if ($Newline) { [Console]::WriteLine($out) } else { [Console]::Write($out) }
}

function cbgl { cbg @args -Newline }

# ============================================================
# 4. Rainbow & Gradients
# ============================================================
function mc {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Arguments
    )
    $paletteKeys = @()
    $style = ""
    $textParts = @()

    $i = 0
    :argLoop while ($i -lt $Arguments.Count) {
        $arg = $Arguments[$i]
        switch -Regex ($arg) {
            '^(-b|--blue)$'    { $paletteKeys += 'blue'; $i++; continue argLoop }
            '^(-c|--cyan)$'    { $paletteKeys += 'cyan'; $i++; continue argLoop }
            '^(-g|--green)$'   { $paletteKeys += 'green'; $i++; continue argLoop }
            '^(-r|--red)$'     { $paletteKeys += 'red'; $i++; continue argLoop }
            '^(-pk|--pink)$'   { $paletteKeys += 'pink'; $i++; continue argLoop }
            '^--fire$'         { $paletteKeys += 'fire'; $i++; continue argLoop }
            '^--ice$'          { $paletteKeys += 'ice'; $i++; continue argLoop }
            '^--sunset$'       { $paletteKeys += 'sunset'; $i++; continue argLoop }
            '^(-p|--pastel)$'  { $paletteKeys += 'pastel'; $i++; continue argLoop }
            '^(-n|--neon)$'    { $paletteKeys += 'neon'; $i++; continue argLoop }
            '^(-d|--default)$' { $paletteKeys += 'default'; $i++; continue argLoop }
            '^[bdiu]{1,4}$' {
                if ($style -eq "" -and $i -lt ($Arguments.Count - 1)) {
                    $style = $arg
                    $i++
                    continue argLoop
                }
            }
        }
        $textParts += $arg
        $i++
    }

    if ($paletteKeys.Count -eq 0) { $paletteKeys += 'default' }

    $combinedPalette = @()
    foreach ($key in $paletteKeys) {
        if ($script:RC_PALETTES.ContainsKey($key)) {
            $combinedPalette += $script:RC_PALETTES[$key]
        }
    }
    if ($combinedPalette.Count -eq 0) { $combinedPalette = $script:RC_PALETTES['default'] }

    $text = $textParts -join ' '
    $styleEsc = script:Build-StyleEscape $style
    $sb = [System.Text.StringBuilder]::new()

    for ($idx = 0; $idx -lt $text.Length; $idx++) {
        $ch = $text[$idx]
        $color = $combinedPalette[$idx % $combinedPalette.Count]
        $fgEsc = script:Get-Fg $color
        $null = $sb.Append("${styleEsc}${fgEsc}${ch}")
    }
    $null = $sb.Append($script:RST)
    [Console]::WriteLine($sb.ToString())
}

function rainbow_palette { mc @args }

# ============================================================
# 5. Random Color Engine (Stateful & Slot-based)
# ============================================================
function rc {
    param(
        [Parameter(Position=0)][string]$SlotOrStyle,
        [Parameter(Position=1, ValueFromRemainingArguments=$true)][string[]]$Text,
        [string]$Slot = "",
        [string]$Palette = "default"
    )
    $pal = if ($script:RC_PALETTES.ContainsKey($Palette)) { $script:RC_PALETTES[$Palette] } else { $script:RC_PALETTES['default'] }
    
    $pickedColor = $null
    if ($Slot -ne "") {
        if (-not $script:STATEFUL_SLOTS.ContainsKey($Slot)) {
            $script:STATEFUL_SLOTS[$Slot] = Get-Random -InputObject $pal
        }
        $pickedColor = $script:STATEFUL_SLOTS[$Slot]
    } else {
        $pickedColor = Get-Random -InputObject $pal
    }
    $script:LAST_COLOR = $pickedColor

    cn "$pickedColor" $SlotOrStyle $Text
}

function rc1 { rc @args -Palette 'pastel' }
function rc2 { rc @args -Palette 'neon' }
function rc3 { rc @args -Palette 'dim' }
function rc4 { rc @args -Palette 'dim' }

# ============================================================
# 6. Random Per-Character Styling
# ============================================================
function rcc {
    param(
        [Parameter(Position=0)][string]$StyleOrText,
        [Parameter(Position=1, ValueFromRemainingArguments=$true)][string[]]$RemainingText,
        [string]$Palette = 'default'
    )
    $pal = if ($script:RC_PALETTES.ContainsKey($Palette)) { $script:RC_PALETTES[$Palette] } else { $script:RC_PALETTES['default'] }
    $style = ""
    $textParts = @()

    if ($StyleOrText -match '^[bdiu]{1,4}$') {
        $style = $StyleOrText
        $textParts = $RemainingText
    } else {
        if ($null -ne $StyleOrText) { $textParts += $StyleOrText }
        if ($RemainingText.Count -gt 0) { $textParts += $RemainingText }
    }

    $text = $textParts -join ' '
    $styleEsc = script:Build-StyleEscape $style
    $sb = [System.Text.StringBuilder]::new()
    $lastCol = -1

    for ($idx = 0; $idx -lt $text.Length; $idx++) {
        $ch = $text[$idx]
        if ($ch -eq ' ') {
            $null = $sb.Append(' ')
            continue
        }
        $avail = $pal | Where-Object { $_ -ne $lastCol }
        $chosen = Get-Random -InputObject $avail
        $lastCol = $chosen
        $fgEsc = script:Get-Fg $chosen
        $null = $sb.Append("${styleEsc}${fgEsc}${ch}")
    }
    $null = $sb.Append($script:RST)
    [Console]::WriteLine($sb.ToString())
}

function rcc1 { rcc @args -Palette 'pastel' }
function rcc2 { rcc @args -Palette 'neon' }

# ============================================================
# 7. Status Helpers
# ============================================================
function _warn { cn 'y'   'b' "$($args -join ' ') ⚠" }
function _er   { cn '196' 'b' "$($args -join ' ') ⛔" }
function _sc   { cn 'lg'  'b' "$($args -join ' ') ✅" }
function _ok   { _sc @args }
function _ep   { cn '45'  'b' "$($args -join ' ') ℹ" }

# ============================================================
# 8. Tables, Dividers & Box Cards
# ============================================================
function hline {
    param([int]$Width = 60, [int]$Color = 240, [string]$Char = "▬")
    $esc = if ($Color -gt 0) { script:Get-Fg $Color } else { $script:DIM }
    $line = $Char * $Width
    [Console]::WriteLine("  ${esc}${line}$script:RST")
}

function box_card {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Arguments
    )
    if ($Arguments.Count -eq 0) { return }

    $border = 240
    $lines = @()

    $i = 0
    :boxLoop while ($i -lt $Arguments.Count) {
        $arg = $Arguments[$i]
        if ($arg -match '^(-b|--border|-Border)$') {
            if ($i + 1 -lt $Arguments.Count) {
                $border = [int]$Arguments[$i + 1]
                $i += 2
                continue boxLoop
            }
        }
        $lines += $arg
        $i++
    }

    if ($lines.Count -eq 0) { return }

    # Clean ANSI to measure visible width accurately
    $plainLines = @()
    foreach ($l in $lines) {
        $plain = $l -replace "$([char]27)\[[0-9;?]*[a-zA-Z]", ""
        $plainLines += $plain
    }

    $maxW = 36
    foreach ($pl in $plainLines) {
        if ($pl -ne '---' -and $pl.Length -gt $maxW) {
            $maxW = $pl.Length
        }
    }

    $bc = script:Get-Fg $border
    $div = "─" * ($maxW + 2)

    [Console]::WriteLine("${bc}╭${div}╮$script:RST")
    for ($idx = 0; $idx -lt $lines.Count; $idx++) {
        $raw = $lines[$idx]
        $plain = $plainLines[$idx]
        if ($raw -eq '---') {
            [Console]::WriteLine("${bc}├${div}┤$script:RST")
        } else {
            $pad = " " * ($maxW - $plain.Length)
            [Console]::WriteLine("${bc}│$script:RST ${raw}${pad} ${bc}│$script:RST")
        }
    }
    [Console]::WriteLine("${bc}╰${div}╯$script:RST")
}

function ctab {
    param(
        [Parameter(Mandatory=$true, Position=0)][string]$Spec,
        [Parameter(Position=1, ValueFromRemainingArguments=$true)][string[]]$Values
    )
    $colSpecs = $Spec -split '\s+'
    $output = "  "
    for ($i = 0; $i -lt $colSpecs.Count; $i++) {
        $part = $colSpecs[$i]
        $split = $part -split ':'
        $colStyle = $split[0]
        $width = if ($split.Length -gt 1) { [int]$split[1] } else { 0 }
        
        $val = if ($i -lt $Values.Count) { $Values[$i] } else { "" }
        $colorNum = $colStyle -replace '[^0-9]', ''
        $st = $colStyle -replace '[0-9]', ''

        $esc = ""
        if ($colorNum -ne "" -and [int]$colorNum -gt 0) { $esc += script:Get-Fg ([int]$colorNum) }
        $esc += script:Build-StyleEscape $st

        if ($width -gt 0) {
            $output += ("${esc}{0,-$width}$script:RST" -f $val) + "  "
        } else {
            $output += "${esc}${val}$script:RST  "
        }
    }
    [Console]::WriteLine($output)
}

# ============================================================
# 9. 256-Color Reference Charts
# ============================================================
function c256 {
    for ($i = 0; $i -le 255; $i++) {
        $str = "{0,3}" -f $i
        $fgEsc = script:Get-Fg $i
        [Console]::Write("${fgEsc}${str}$script:RST ")
        if (($i + 1) % 16 -eq 0) { [Console]::WriteLine() }
    }
}

# Export functions for PowerShell Module
Export-ModuleMember -Function c, cn, color, cbg, cbgl, mc, rainbow_palette, `
    rc, rc1, rc2, rc3, rc4, rcc, rcc1, rcc2, `
    _warn, _er, _sc, _ok, _ep, hline, box_card, ctab, c256
