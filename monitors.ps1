<#
.SYNOPSIS
    Toggles between two monitor layouts.

    If Monitor 2 is currently ACTIVE:
        -> make Monitor 1 primary, disconnect Monitor 2, extend to Monitor 4
    If Monitor 2 is currently DISCONNECTED:
        -> disconnect Monitor 4, extend to Monitor 2, make Monitor 2 primary

.NOTES
    Uses the DisplayConfig module (PowerShell Gallery, by MartinGC94), which
    talks to the same Windows display API as Settings > Display, so it can see
    monitors that are disconnected there. Display IDs match the numbers shown
    in Settings > Display.

    One-time install (current user, no admin needed):
        Install-Module DisplayConfig -Scope CurrentUser

    To see your IDs and their current state:
        Get-DisplayInfo
#>

param(
    [int]$MonitorA = 1,   # stays on in both layouts
    [int]$MonitorB = 2,   # toggled
    [int]$MonitorC = 4    # toggled (opposite of MonitorB)
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Module -ListAvailable -Name DisplayConfig)) {
    throw "DisplayConfig module not installed. Run: Install-Module DisplayConfig -Scope CurrentUser"
}
Import-Module DisplayConfig

$displayB = Get-DisplayInfo | Where-Object DisplayId -eq $MonitorB
if (-not $displayB) {
    throw "Display $MonitorB not found. Run Get-DisplayInfo to check the IDs."
}

if ($displayB.Active) {
    Write-Host "Monitor $MonitorB is active -> Monitor $MonitorA (primary) + Monitor $MonitorC"

    # Move primary off Monitor B before it gets disabled
    Set-DisplayPrimary -DisplayId $MonitorA
    # Enable C and disable B in a single topology change
    Enable-Display -DisplayId $MonitorC -DisplayIdToDisable $MonitorB
}
else {
    Write-Host "Monitor $MonitorB is disconnected -> Monitor $MonitorB (primary), Monitor $MonitorC off"

    # Enable B and disable C in a single topology change
    Enable-Display -DisplayId $MonitorB -DisplayIdToDisable $MonitorC
    Set-DisplayPrimary -DisplayId $MonitorB
}

Write-Host "Done."