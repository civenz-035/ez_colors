@{
    RootModule           = 'ez_colors.psm1'
    ModuleVersion        = '3.0.0'
    GUID                 = 'b28b7e28-5e26-4b83-a441-2c0738a1cf45'
    Author               = 'joez (civenz-035)'
    CompanyName          = 'civenz'
    Copyright            = '(c) 2026 joez. MIT License.'
    Description          = 'Zero-dependency ANSI color engine, random palette generator, gradients and box cards for PowerShell 5.1 & PowerShell 7+'
    PowerShellVersion    = '5.1'
    FunctionsToExport    = @(
        'c', 'cn', 'color', 'cbg', 'cbgl',
        'mc', 'rainbow_palette',
        'rc', 'rc1', 'rc2', 'rc3', 'rc4',
        'rcc', 'rcc1', 'rcc2',
        '_warn', '_er', '_sc', '_ok', '_ep',
        'hline', 'box_card', 'ctab', 'c256'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
    PrivateData          = @{
        PSData = @{
            Tags       = @('Color', 'ANSI', 'Terminal', 'CLI', 'Rainbow', 'Palette', 'CrossPlatform')
            ProjectUri = 'https://github.com/civenz-035/ez_colors'
            LicenseUri = 'https://github.com/civenz-035/ez_colors/blob/main/LICENSE'
        }
    }
}

