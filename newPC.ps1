winget list --id xanderfrangos.twinkletray --exact --accept-source-agreements *> $null
if ($LASTEXITCODE -ne 0) {
    winget install xanderfrangos.twinkletray
} else {
    Write-Host "Twinkle Tray already installed"
}

if (-not (Get-Module -ListAvailable -Name DisplayConfig)) {
    Install-Module DisplayConfig -Scope CurrentUser
} else {
    Write-Host "DisplayConfig module already installed"
}

winget list --id AutoHotkey.AutoHotkey --exact --accept-source-agreements *> $null
if ($LASTEXITCODE -ne 0) {
    winget install AutoHotkey.AutoHotkey
} else {
    Write-Host "AutoHotkey already installed"
}

$shortcutPath = Join-Path ([Environment]::GetFolderPath('Startup')) 'Hotkeys.lnk'
if (-not (Test-Path $shortcutPath)) {
    $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcutPath)
    $shortcut.TargetPath = Join-Path $PSScriptRoot 'Hotkeys.ahk'
    $shortcut.WorkingDirectory = $PSScriptRoot
    $shortcut.Save()
} else {
    Write-Host "Hotkeys.ahk already in startup"
}
