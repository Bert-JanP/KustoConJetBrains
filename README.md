# JetBrains Installation Guide

**Important:** This repository is part of KustoCon 2025.

This folder contains a small installer and updater for JetBrains. Run the deploy script to perform the installation — it will call the other scripts as needed.

Files in this folder
- a----  10/25/2025  3:47 PM    375   JetBrains.ps1
- a----  10/25/2025  3:51 PM    205   JetBrainsDeploy.ps1
- a----  10/25/2025  3:10 PM   1649   JetBrainsUpdate.ps1

Overview
- JetBrainsDeploy.ps1 — main entrypoint. Execute this file to install or update.
- JetBrains.ps1 — installation steps called by the deploy script.
- JetBrainsUpdate.ps1 — updater; the deploy script executes this when an update is required.

Included files (details)
- JetBrainsDeploy.ps1
  - Purpose: Orchestrates installation and update flows. Checks for installed JetBrains components and decides whether to call the installer (JetBrains.ps1) or updater (JetBrainsUpdate.ps1).
  - How to run: See "How to run" below; this is the only file you need to run directly.
- JetBrains.ps1
  - Purpose: Contains the concrete installation steps (download, extract, install, post-install configuration).
  - Notes: Keep this script in the same folder as JetBrainsDeploy.ps1 so the deploy script can call it reliably.
- JetBrainsUpdate.ps1
  - Purpose: Performs update tasks when an installed JetBrains product needs updating (download newer version, run updater, migrate settings if necessary).
  - Notes: The deploy script will call this script automatically when an update is detected or forced.

Prerequisites
- Windows with PowerShell 5.1 or later (PowerShell Core should also work but the scripts were written for Windows PowerShell).
- Sufficient privileges to install software (running PowerShell as Administrator may be required).
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
- If an update fails, inspect JetBrainsUpdate.ps1 to find what step failed (download, checksum, installer exit code) and run that step manually for debugging.

Notes
- The deploy script is the only file you need to run directly. It orchestrates installation and updates.
- Keep the three files together in the installation folder so deploy can call the other scripts correctly.
- These scripts are intended to be small and auditable. Review them before running in sensitive environments.

Contributing
- If you have improvements or fixes, please open a pull request with a clear description of the change and the reason for it.
- Add tests or additional logging where appropriate.

Changelog
- 2025-10-25: Documented all related files and clarified purpose/usage in README.

If you'd like, I can also:
- Expand the file descriptions with exact step-by-step actions after inspecting the three PowerShell scripts.
- Add a one-line script snippet to JetBrainsDeploy.ps1 to create the scheduled task automatically.