#Requires AutoHotkey v2.0
#SingleInstance Force

; F13 → run brightness.ps1
F13::Run 'pwsh -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "' A_ScriptDir '\brightness.ps1"'

; F14 → run monitors
F14::Run 'pwsh -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "' A_ScriptDir '\monitors.ps1"'
