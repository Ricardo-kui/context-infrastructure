param(
    [Parameter(Mandatory = $true)]
    [string]$BundlePath,
    [string]$CodexHome = (Join-Path $env:USERPROFILE ".codex"),
    [string]$RepoRoot,
    [switch]$ImportAuth,
    [switch]$ImportMemories,
    [switch]$SkipRepoClone,
    [switch]$SkipTaskRegistration
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

function Get-EnvKeysFromConfig {
    param([string]$ConfigPath)

    if (-not (Test-Path -LiteralPath $ConfigPath)) {
        return @()
    }

    $keys = @()
    $matches = Select-String -Path $ConfigPath -Pattern 'env_key\s*=\s*"([^"]+)"' -AllMatches
    foreach ($match in $matches) {
        foreach ($group in $match.Matches) {
            $keys += $group.Groups[1].Value
        }
    }
    return $keys | Sort-Object -Unique
}

function Test-ProjectRoots {
    param([string]$PortfolioPath)

    if (-not (Test-Path -LiteralPath $PortfolioPath)) {
        return
    }

    $missing = @()
    $matches = Select-String -Path $PortfolioPath -Pattern '^- Root path:\s*(.+)$'
    foreach ($match in $matches) {
        $pathText = $match.Matches[0].Groups[1].Value.Trim()
        if (-not (Test-Path -LiteralPath $pathText)) {
            $missing += $pathText
        }
    }

    if ($missing.Count -gt 0) {
        Write-Warning "These project roots do not exist on this machine yet:"
        foreach ($pathText in $missing) {
            Write-Warning "  - $pathText"
        }
    }
}

if (-not (Test-Path -LiteralPath $BundlePath)) {
    throw "Bundle not found: $BundlePath"
}

$extractRoot = Join-Path $env:TEMP ("codex-import-" + [guid]::NewGuid().ToString("N"))
Ensure-Directory -Path $extractRoot

try {
    Expand-Archive -LiteralPath $BundlePath -DestinationPath $extractRoot -Force

    $manifestPath = Join-Path $extractRoot "manifest.json"
    if (-not (Test-Path -LiteralPath $manifestPath)) {
        throw "manifest.json not found in bundle."
    }

    $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json

    if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
        if (-not [string]::IsNullOrWhiteSpace($manifest.repo.preferred_path)) {
            $RepoRoot = [string]$manifest.repo.preferred_path
        }
        else {
            $RepoRoot = "D:\Codex\context-infrastructure"
        }
    }

    Ensure-Directory -Path $CodexHome

    $bundleCodex = Join-Path $extractRoot ".codex"
    $restored = [System.Collections.Generic.List[string]]::new()

    if (Copy-PathIfExists -Source (Join-Path $bundleCodex "config.toml") -Destination (Join-Path $CodexHome "config.toml")) {
        $restored.Add(".codex\config.toml")
    }
    if (Copy-PathIfExists -Source (Join-Path $bundleCodex "AGENTS.md") -Destination (Join-Path $CodexHome "AGENTS.md")) {
        $restored.Add(".codex\AGENTS.md")
    }
    if (Copy-PathIfExists -Source (Join-Path $bundleCodex "skills") -Destination (Join-Path $CodexHome "skills")) {
        $restored.Add(".codex\skills")
    }
    if (Copy-PathIfExists -Source (Join-Path $bundleCodex "rules\context-infrastructure") -Destination (Join-Path $CodexHome "rules\context-infrastructure")) {
        $restored.Add(".codex\rules\context-infrastructure")
    }
    if ($ImportAuth -and (Copy-PathIfExists -Source (Join-Path $bundleCodex "auth.json") -Destination (Join-Path $CodexHome "auth.json"))) {
        $restored.Add(".codex\auth.json")
    }
    if ($ImportMemories -and (Copy-PathIfExists -Source (Join-Path $bundleCodex "memories") -Destination (Join-Path $CodexHome "memories"))) {
        $restored.Add(".codex\memories")
    }

    $repoReady = $false
    if (-not $SkipRepoClone -and -not (Test-Path -LiteralPath $RepoRoot)) {
        if (-not [string]::IsNullOrWhiteSpace($manifest.repo.remote)) {
            Ensure-Directory -Path (Split-Path -Parent $RepoRoot)
            git clone $manifest.repo.remote $RepoRoot | Out-Null
        }
    }

    if (Test-Path -LiteralPath (Join-Path $RepoRoot ".git")) {
        $repoReady = $true
    }
    elseif (Test-Path -LiteralPath $RepoRoot) {
        $repoReady = $true
        Write-Warning "Repo root exists but is not a git clone: $RepoRoot"
    }

    $portfolioRelPath = [string]$manifest.repo.portfolio_relpath
    if (-not [string]::IsNullOrWhiteSpace($portfolioRelPath) -and $repoReady) {
        $portfolioSource = Join-Path $extractRoot ("repo-overlay\" + $portfolioRelPath)
        $portfolioDestination = Join-Path $RepoRoot $portfolioRelPath
        if (Copy-PathIfExists -Source $portfolioSource -Destination $portfolioDestination) {
            $restored.Add($portfolioRelPath)
            Test-ProjectRoots -PortfolioPath $portfolioDestination
        }
    }

    if ($repoReady) {
        $syncScript = Join-Path $RepoRoot "tools\sync_codex_context.ps1"
        if (Test-Path -LiteralPath $syncScript) {
            & $syncScript
        }
    }

    if (-not $SkipTaskRegistration -and $repoReady) {
        $registerScript = Join-Path $RepoRoot "tools\register_ai_heartbeat_tasks.ps1"
        if (Test-Path -LiteralPath $registerScript) {
            $observerTime = $null
            $reflectorTime = $null
            $reflectorDay = "Sunday"

            if ($manifest.heartbeat.observer -and $manifest.heartbeat.observer.time) {
                $observerTime = [string]$manifest.heartbeat.observer.time
            }
            if ($manifest.heartbeat.reflector -and $manifest.heartbeat.reflector.time) {
                $reflectorTime = [string]$manifest.heartbeat.reflector.time
            }
            if ($manifest.heartbeat.reflector -and $manifest.heartbeat.reflector.days -and $manifest.heartbeat.reflector.days.Count -gt 0) {
                $reflectorDay = [string]$manifest.heartbeat.reflector.days[0]
            }

            if ($observerTime -and $reflectorTime) {
                try {
                    & $registerScript -ObserverTime $observerTime -ReflectorTime $reflectorTime -ReflectorDay $reflectorDay
                }
                catch {
                    Write-Warning $_.Exception.Message
                    Write-Warning "If you want S4U background mode, rerun this as Administrator:"
                    Write-Warning "  powershell -ExecutionPolicy Bypass -File `"$registerScript`" -ObserverTime $observerTime -ReflectorTime $reflectorTime -ReflectorDay $reflectorDay"
                }
            }
        }
    }

    $envKeys = Get-EnvKeysFromConfig -ConfigPath (Join-Path $CodexHome "config.toml")

    Write-Output "Imported Codex setup."
    Write-Output "Restored items:"
    foreach ($item in $restored) {
        Write-Output "  - $item"
    }
    Write-Output "Codex home: $CodexHome"
    Write-Output "Repo path: $RepoRoot"

    if ($envKeys.Count -gt 0) {
        Write-Output "Recreate these environment variables on the target machine:"
        foreach ($envKey in $envKeys) {
            Write-Output "  - $envKey"
        }
    }
}
finally {
    if (Test-Path -LiteralPath $extractRoot) {
        Remove-Item -LiteralPath $extractRoot -Recurse -Force
    }
}
