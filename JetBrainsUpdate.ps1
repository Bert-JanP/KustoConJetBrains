$Location = "$env:LOCALAPPDATA\JetBrains\UpdateJetBrain.ps1"

$TaskName        = "UpdateJetBrainsOnce"
$TaskDescription = "Runs JetBrains update script once (scheduled 5 minutes from creation) for the current user."

try {
    # Calculate run time: 5 minutes from now
    $runTime = (Get-Date).AddMinutes(5)

    # Create a one-time trigger for that exact time
    $trigger = New-ScheduledTaskTrigger -Once -At $runTime

    # Action: run PowerShell to execute the target script (quote path to handle spaces)
    $escapedPath = $Location -replace '"','\"'
    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$escapedPath`""

    # Register the task for the current interactive user with limited privileges (no admin)
    $currentUser = "$env:USERDOMAIN\$env:USERNAME"
    $principal = New-ScheduledTaskPrincipal -UserId $currentUser -LogonType Interactive -RunLevel Limited

    # Register (create or overwrite) the scheduled task
    Register-ScheduledTask -TaskName $TaskName -Trigger $trigger -Action $action -Principal $principal -Description $TaskDescription -Force

    Write-Host "Scheduled task '$TaskName' created to run once at $($runTime.ToString('yyyy-MM-dd HH:mm:ss'))."

    # Note: the task is scheduled for 5 minutes from now. Do not Start-ScheduledTask here,
    # because starting it would run it immediately instead of waiting 5 minutes.
    # If you want to run it now for testing, uncomment the next line:
    # Start-ScheduledTask -TaskName $TaskName

} catch {
    Write-Error "Failed to create scheduled task: $_"
    exit 1
}