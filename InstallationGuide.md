# JetBrains Installation Guide

This folder contains the small installer and updater for JetBrains. Run the deploy script to perform the installation — it will call the other scripts as needed.

Files in this folder
- a----  10/25/2025  3:47 PM    375   JetBrains.ps1
- a----  10/25/2025  3:51 PM    205   JetBrainsDeploy.ps1
- a----  10/25/2025  3:10 PM   1649   JetBrainsUpdate.ps1

Overview
- JetBrainsDeploy.ps1 — main entrypoint. Execute this file to install or update.
- JetBrains.ps1 — called by the deploy script; contains the installation steps.
- JetBrainsUpdate.ps1 — updater; the deploy script executes this when an update is required.

Prerequisites
- Windows with PowerShell.
- Sufficient privileges to install software (running as Administrator may be required).
- Execution policy that allows running local scripts (or run with an explicit bypass).

How to run (recommended)
1. Open PowerShell as Administrator (if required).
2. From the folder containing these files run:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\JetBrainsDeploy.ps1
```
The deploy script will call JetBrains.ps1 and JetBrainsUpdate.ps1 as needed.

Optional: create a scheduled task (start JetBrains daily at 08:30)
If you want JetBrains to auto-start every morning at 08:30, create a scheduled task that runs the JetBrains executable (example path shown uses the current user's LocalAppData):
```powershell
schtasks /Create /SC DAILY /TN JetBrainsAutoStart /TR "`"$env:LOCALAPPDATA\JetBrains\JetBrains.exe`"" /ST 08:30 /F
```
Run that command in an elevated prompt if you want the task available to all users or to write to Task Scheduler.

Troubleshooting
- If the script is blocked by ExecutionPolicy, use the -ExecutionPolicy Bypass flag as shown above.
- If a script fails due to permissions, rerun PowerShell as Administrator.
- Check the script contents (they are short) to see what external resources they expect (network access, installer files, etc.).

Notes
- The deploy script is the only file you need to run directly. It orchestrates installation and updates.
- Keep the three files together in the installation folder so deploy can call the other scripts correctly.

If you want, I can:
- Add a one-line script that creates the scheduled task automatically from the deploy script.
- Inspect the three PowerShell scripts and document exactly what each step does.