param(
    [string]$ObserverTime = "21:00",
    [string]$ReflectorTime = "21:30",
    [string]$ReflectorDay = "SUN"
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$observerCmd = Join-Path $repoRoot "tools\run_ai_heartbeat_observer.cmd"
$reflectorCmd = Join-Path $repoRoot "tools\run_ai_heartbeat_reflector.cmd"

if (-not (Test-Path -LiteralPath $observerCmd)) {
    throw "Observer wrapper not found: $observerCmd"
}
if (-not (Test-Path -LiteralPath $reflectorCmd)) {
    throw "Reflector wrapper not found: $reflectorCmd"
}

$observerTaskName = "Codex AIHeartbeat Observer"
$reflectorTaskName = "Codex AIHeartbeat Reflector"

schtasks /Create /TN $observerTaskName /SC DAILY /ST $ObserverTime /TR "`"$observerCmd`"" /F | Out-Host
schtasks /Create /TN $reflectorTaskName /SC WEEKLY /D $ReflectorDay /ST $ReflectorTime /TR "`"$reflectorCmd`"" /F | Out-Host

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Hours 72)

Set-ScheduledTask -TaskName $observerTaskName -Settings $settings | Out-Null
Set-ScheduledTask -TaskName $reflectorTaskName -Settings $settings | Out-Null

Write-Output "Registered scheduled tasks:"
Write-Output "  - $observerTaskName at $ObserverTime daily"
Write-Output "  - $reflectorTaskName at $ReflectorDay $ReflectorTime weekly"
