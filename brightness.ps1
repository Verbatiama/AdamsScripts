param(
    [ValidateRange(0, 100)]
    [int]$Brightness
)

$programPath = "$Env:LOCALAPPDATA\Programs\twinkle-tray\Twinkle Tray.exe"

if ($PSBoundParameters.ContainsKey('Brightness')) {
    Write-Host "Setting all monitors to $Brightness"
    & $programPath --All --Set=$Brightness
    return
}

$output = & $programPath --List 2>&1 | Out-String

# Strip ANSI color codes (the keys are printed in cyan)
$output = $output -replace "\x1b\[[0-9;]*m", ''

$monitors = foreach ($block in ($output -split '(\r?\n){2,}')) {
    $props = [ordered]@{}
    foreach ($line in ($block -split '\r?\n')) {
        if ($line -match '^\s*(\w+):\s*(.*)$') { $props[$Matches[1]] = $Matches[2].Trim() }
    }
    if ($props.Contains('MonitorNum')) {
        $props.MonitorNum = [int]$props.MonitorNum
        $props.Brightness = [int]$props.Brightness
        [pscustomobject]$props
    }
}
$meanBrightness = ($monitors | Measure-Object -Property Brightness -Average).Average

if ($meanBrightness -lt 50) {
    Write-Host "Mean brightness is $meanBrightness -> setting to 100"
    & $programPath --All --Set=100
}
else {
    Write-Host "Mean brightness is $meanBrightness -> setting to 0"
    & $programPath --All --Set=0
}