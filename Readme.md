# AnyDesk ID Resetter

A lightweight and safe Batch script to reset AnyDesk ID on Windows by performing a deep clean of configuration files and registry keys.

## What it does:
1. **Admin Check:** Ensures the script runs with necessary privileges.
2. **Service Management:** Stops AnyDesk service and processes safely.
3. **Deep Clean:** - Removes `%ProgramData%\AnyDesk`.
   - Cleans all user profiles in `AppData\Roaming\AnyDesk` (handles multiple users).
   - Wipes registry keys in `HKCU` and `HKLM` (including WOW6432Node).
4. **Auto-Restart:** Re-enables the service and launches AnyDesk automatically.

## How to use:
1. Download `reset_anydesk.bat`.
2. Right-click on the file and select **Run as Administrator**.
3. Wait for the "Done" message.
4. Your AnyDesk will launch with a brand new ID.

## Requirements:
- Windows OS (7/8/10/11)
- Administrator privileges

> **Note:** This will clear your "Recent Sessions" and "Unattended Access" settings.