param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName,
    [string]$BaseDir = "D:\Codex\projects",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function New-DirIfMissing {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Write-TextIfAllowed {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$Content,
        [bool]$AllowOverwrite = $false
    )
    if ((Test-Path -LiteralPath $Path) -and -not $AllowOverwrite) {
        return
    }
    $Content | Set-Content -LiteralPath $Path -Encoding UTF8
}

$safeName = $ProjectName.ToLower() -replace "[^a-z0-9_\\-]", "_" -replace "_{2,}", "_"
if ([string]::IsNullOrWhiteSpace($safeName)) {
    throw "ProjectName is empty after normalization."
}

$projectRoot = Join-Path $BaseDir $safeName
if ((Test-Path -LiteralPath $projectRoot) -and -not $Force) {
    throw "Project directory already exists: $projectRoot. Use -Force to continue."
}

New-DirIfMissing -Path $projectRoot

$dirs = @(
    "docs\research_design",
    "docs\literature_notes",
    "docs\meeting_notes",
    "docs\submission",
    "data\raw",
    "data\interim",
    "data\processed",
    "data\external_policy",
    "code\python",
    "code\stata",
    "code\shared",
    "models\baseline",
    "models\robustness",
    "models\heterogeneity",
    "models\mechanism",
    "outputs\tables",
    "outputs\figures",
    "outputs\logs",
    "outputs\appendices",
    "papers\main",
    "papers\sections",
    "papers\revisions",
    "replication\package",
    "contexts\daily_records"
)

foreach ($d in $dirs) {
    New-DirIfMissing -Path (Join-Path $projectRoot $d)
}

$readme = @"
# $safeName

## Scope
- Research domain: strategic management
- Primary identification: DiD (extend with IV/RDD/PSM when needed)

## Quick Start
1. Put raw data in `data/raw/` (read-only).
2. Build cleaned data into `data/interim/` and `data/processed/`.
3. Keep estimation scripts in `code/python/` or `code/stata/`.
4. Save outputs into `outputs/tables/`, `outputs/figures/`, `outputs/logs/`.
5. Draft paper sections in `papers/sections/`.

## Reproducibility
- Record key runs in `outputs/logs/`.
- Keep model versions under `models/`.
- Prepare final package in `replication/package/`.
"@

$replicationReadme = @"
# Replication Package

Include:
- data dictionary
- run order
- environment/dependency notes
- script entrypoints
"@

$runLogTemplate = @"
# Daily Record

- Date:
- Goal:
- Main result:
- Issues:
- Next step:
"@

Write-TextIfAllowed -Path (Join-Path $projectRoot "README.md") -Content $readme -AllowOverwrite $Force
Write-TextIfAllowed -Path (Join-Path $projectRoot "replication\README.md") -Content $replicationReadme -AllowOverwrite $Force
Write-TextIfAllowed -Path (Join-Path $projectRoot "contexts\daily_records\template.md") -Content $runLogTemplate -AllowOverwrite $Force

Write-Output "Scaffold created at: $projectRoot"
Write-Output "Tip: add this path into rules/WORKSPACE.md active project mapping if needed."
