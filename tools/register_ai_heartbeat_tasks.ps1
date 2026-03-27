param(
    [string]$ObserverTime = "21:00",
    [string]$ReflectorTime = "21:30",
    [string]$ReflectorDay = "Sunday"
)

$ErrorActionPreference = "Stop"

function Parse-DailyTime {
    param([string]$TimeText)
    return [datetime]::Today.Add([timespan]::Parse($TimeText))
}

function Parse-Weekday {
    param([string]$DayText)
    $normalized = $DayText.Trim().ToUpperInvariant()
    switch ($normalized) {
        "SUN" { return "Sunday" }
        "MON" { return "Monday" }
        "TUE" { return "Tuesday" }
        "WED" { return "Wednesday" }
        "THU" { return "Thursday" }
        "FRI" { return "Friday" }
        "SAT" { return "Saturday" }
        default { return (Get-Culture).TextInfo.ToTitleCase($DayText.ToLowerInvariant()) }
    }
}

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
$userId = "$env:COMPUTERNAME\$env:USERNAME"
$principal = New-ScheduledTaskPrincipal -UserId $userId -LogonType S4U -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Hours 72)

$observerAction = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$observerCmd`"" -WorkingDirectory $repoRoot
$reflectorAction = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$reflectorCmd`"" -WorkingDirectory $repoRoot
$observerTrigger = New-ScheduledTaskTrigger -Daily -At (Parse-DailyTime -TimeText $ObserverTime)
$reflectorTrigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek (Parse-Weekday -DayText $ReflectorDay) -At (Parse-DailyTime -TimeText $ReflectorTime)

try {
    Register-ScheduledTask -TaskName $observerTaskName -Action $observerAction -Trigger $observerTrigger -Principal $principal -Settings $settings -Force | Out-Null
    Register-ScheduledTask -TaskName $reflectorTaskName -Action $reflectorAction -Trigger $reflectorTrigger -Principal $principal -Settings $settings -Force | Out-Null
}
catch {
    if ($_.Exception.Message -match "Access is denied") {
        throw "S4U background registration requires an elevated PowerShell window. Re-run this script as Administrator to switch the tasks from interactive mode to background mode."
    }
    throw
}

Write-Output "Registered scheduled tasks:"
Write-Output "  - $observerTaskName at $ObserverTime daily (S4U background mode)"
Write-Output "  - $reflectorTaskName at $ReflectorDay $ReflectorTime weekly (S4U background mode)"
