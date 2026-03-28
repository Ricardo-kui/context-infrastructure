param(
    [string]$BundlePath,
    [string]$CodexHome = (Join-Path $env:USERPROFILE ".codex"),
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [switch]$IncludeAuth,
    [switch]$IncludeMemories
)

$ErrorActionPreference = "Stop"

function Ensure-Directory {
    param([string]$Path)
    if (-not [string]::IsNullOrWhiteSpace($Path) -and -not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Copy-PathIfExists {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        return $false
    }

    Ensure-Directory -Path (Split-Path -Parent $Destination)
    Copy-Item -LiteralPath $Source -Destination $Destination -Recurse -Force
    return $true
}

function Get-TaskDayNames {
    param([int]$Mask)
    $map = @(
        @{ Bit = 1; Name = "Sunday" },
        @{ Bit = 2; Name = "Monday" },
        @{ Bit = 4; Name = "Tuesday" },
        @{ Bit = 8; Name = "Wednesday" },
        @{ Bit = 16; Name = "Thursday" },
        @{ Bit = 32; Name = "Friday" },
        @{ Bit = 64; Name = "Saturday" }
    )

    $names = @()
    foreach ($entry in $map) {
        if (($Mask -band $entry.Bit) -ne 0) {
            $names += $entry.Name
        }
    }
    return $names
}

function Get-HeartbeatTaskInfo {
    param([string]$TaskName)

    try {
        $task = Get-ScheduledTask -TaskName $TaskName -ErrorAction Stop
    }
    catch {
        return $null
    }

    $trigger = $task.Triggers | Select-Object -First 1
    if (-not $trigger) {
        return @{
            task_name = $TaskName
            available = $true
            frequency = "unknown"
        }
    }

    $info = @{
        task_name = $TaskName
        available = $true
        start_boundary = $trigger.StartBoundary
    }

    $triggerType = $trigger.CimClass.CimClassName
    switch ($triggerType) {
        "MSFT_TaskDailyTrigger" {
            $info.frequency = "daily"
            $info.time = ([datetimeoffset]$trigger.StartBoundary).ToString("HH:mm")
        }
        "MSFT_TaskWeeklyTrigger" {
            $info.frequency = "weekly"
            $info.time = ([datetimeoffset]$trigger.StartBoundary).ToString("HH:mm")
            $info.days = @(Get-TaskDayNames -Mask ([int]$trigger.DaysOfWeek))
        }
        default {
            $info.frequency = $triggerType
        }
    }

    return $info
}

if ([string]::IsNullOrWhiteSpace($BundlePath)) {
    $desktop = [Environment]::GetFolderPath("Desktop")
    if ([string]::IsNullOrWhiteSpace($desktop)) {
        $desktop = $env:USERPROFILE
    }
    $BundlePath = Join-Path $desktop ("codex-migration-{0}.zip" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
}

$bundleDirectory = Split-Path -Parent $BundlePath
Ensure-Directory -Path $bundleDirectory

$stagingRoot = Join-Path $env:TEMP ("codex-migration-" + [guid]::NewGuid().ToString("N"))
Ensure-Directory -Path $stagingRoot

try {
    $codexPayloadRoot = Join-Path $stagingRoot ".codex"
    Ensure-Directory -Path $codexPayloadRoot

    $copiedItems = [System.Collections.Generic.List[string]]::new()

    if (Copy-PathIfExists -Source (Join-Path $CodexHome "config.toml") -Destination (Join-Path $codexPayloadRoot "config.toml")) {
        $copiedItems.Add(".codex\config.toml")
    }
    if (Copy-PathIfExists -Source (Join-Path $CodexHome "AGENTS.md") -Destination (Join-Path $codexPayloadRoot "AGENTS.md")) {
        $copiedItems.Add(".codex\AGENTS.md")
    }
    if (Copy-PathIfExists -Source (Join-Path $CodexHome "skills") -Destination (Join-Path $codexPayloadRoot "skills")) {
        $copiedItems.Add(".codex\skills")
    }
    if (Copy-PathIfExists -Source (Join-Path $CodexHome "rules\context-infrastructure") -Destination (Join-Path $codexPayloadRoot "rules\context-infrastructure")) {
        $copiedItems.Add(".codex\rules\context-infrastructure")
    }
    if ($IncludeAuth -and (Copy-PathIfExists -Source (Join-Path $CodexHome "auth.json") -Destination (Join-Path $codexPayloadRoot "auth.json"))) {
        $copiedItems.Add(".codex\auth.json")
    }
    if ($IncludeMemories -and (Copy-PathIfExists -Source (Join-Path $CodexHome "memories") -Destination (Join-Path $codexPayloadRoot "memories"))) {
        $copiedItems.Add(".codex\memories")
    }

    $portfolioRelPath = "periodic_jobs\ai_heartbeat\config\PROJECT_PORTFOLIO.local.md"
    $portfolioSource = Join-Path $RepoRoot $portfolioRelPath
    if (Copy-PathIfExists -Source $portfolioSource -Destination (Join-Path $stagingRoot ("repo-overlay\" + $portfolioRelPath))) {
        $copiedItems.Add("repo-overlay\$portfolioRelPath")
    }

    $importBootstrap = Join-Path $RepoRoot "tools\import_codex_setup.ps1"
    Copy-PathIfExists -Source $importBootstrap -Destination (Join-Path $stagingRoot "import_codex_setup.ps1") | Out-Null

    $repoRemote = $null
    $repoBranch = $null
    $repoCommit = $null

    try {
        $repoRemote = (git -C $RepoRoot remote get-url origin 2>$null | Select-Object -First 1)
        $repoBranch = (git -C $RepoRoot branch --show-current 2>$null | Select-Object -First 1)
        $repoCommit = (git -C $RepoRoot rev-parse HEAD 2>$null | Select-Object -First 1)
    }
    catch {
    }

    $manifest = @{
        schema_version = 1
        exported_at = (Get-Date).ToString("o")
        source = @{
            computer = $env:COMPUTERNAME
            user = $env:USERNAME
            codex_home = $CodexHome
        }
        repo = @{
            preferred_path = $RepoRoot
            remote = $repoRemote
            branch = $repoBranch
            commit = $repoCommit
            portfolio_relpath = $portfolioRelPath
        }
        heartbeat = @{
            observer = Get-HeartbeatTaskInfo -TaskName "Codex AIHeartbeat Observer"
            reflector = Get-HeartbeatTaskInfo -TaskName "Codex AIHeartbeat Reflector"
        }
        bundle = @{
            includes_auth = [bool]$IncludeAuth
            includes_memories = [bool]$IncludeMemories
            copied_items = @($copiedItems)
        }
        notes = @(
            "API keys and other environment variables are not exported. Recreate them on the target machine.",
            "Auth is excluded by default. Only include auth.json when you fully trust the target machine.",
            "If OneDrive, Sync, or project drive letters differ, update PROJECT_PORTFOLIO.local.md after import."
        )
    }

    $manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $stagingRoot "manifest.json") -Encoding UTF8

    @"
Codex migration bundle
======================

Suggested steps on the target machine:

1. Extract this zip to any folder.
2. Run:
   powershell -ExecutionPolicy Bypass -File .\import_codex_setup.ps1 -BundlePath .\$(Split-Path -Leaf $BundlePath)
3. Log in to Codex again if auth.json was not exported.
4. Recreate required API keys such as SSY_API_KEY.
5. If your project paths differ, edit PROJECT_PORTFOLIO.local.md after import.

This bundle intentionally excludes logs, sessions, sqlite state, caches, and temp files.
"@ | Set-Content -LiteralPath (Join-Path $stagingRoot "README.txt") -Encoding UTF8

    if (Test-Path -LiteralPath $BundlePath) {
        Remove-Item -LiteralPath $BundlePath -Force
    }

    $itemsToArchive = Get-ChildItem -Force -LiteralPath $stagingRoot | Select-Object -ExpandProperty FullName
    Compress-Archive -LiteralPath $itemsToArchive -DestinationPath $BundlePath -Force

    Write-Output "Created migration bundle: $BundlePath"
    Write-Output "Included items:"
    foreach ($item in $copiedItems) {
        Write-Output "  - $item"
    }
}
finally {
    if (Test-Path -LiteralPath $stagingRoot) {
        Remove-Item -LiteralPath $stagingRoot -Recurse -Force
    }
}
