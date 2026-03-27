param(
    [string]$TargetDir = "C:\Users\admin\.codex\rules\context-infrastructure"
)

$ErrorActionPreference = "Stop"

function Copy-ManagedFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,
        [Parameter(Mandatory = $true)]
        [string]$DestinationPath
    )

    $destinationParent = Split-Path -Parent $DestinationPath
    if (-not (Test-Path -LiteralPath $destinationParent)) {
        New-Item -ItemType Directory -Path $destinationParent -Force | Out-Null
    }

    Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Force
}

function Sync-ManagedDirectory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourceDir,
        [Parameter(Mandatory = $true)]
        [string]$DestinationDir
    )

    if (-not (Test-Path -LiteralPath $DestinationDir)) {
        New-Item -ItemType Directory -Path $DestinationDir -Force | Out-Null
    }

    $null = robocopy $SourceDir $DestinationDir /MIR /R:1 /W:1 /NFL /NDL /NJH /NJS /NP
    if ($LASTEXITCODE -ge 8) {
        throw "robocopy failed while syncing '$SourceDir' to '$DestinationDir' (exit code $LASTEXITCODE)."
    }
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

$managedFiles = @(
    "AGENTS.md",
    "README.md",
    "setup_guide.md",
    "CODEX_SETUP.md"
)

$managedDirectories = @(
    "docs",
    "rules"
)

if (-not (Test-Path -LiteralPath $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

foreach ($relativePath in $managedFiles) {
    $sourcePath = Join-Path $repoRoot $relativePath
    if (Test-Path -LiteralPath $sourcePath) {
        $destinationPath = Join-Path $TargetDir $relativePath
        Copy-ManagedFile -SourcePath $sourcePath -DestinationPath $destinationPath
    }
}

foreach ($relativePath in $managedDirectories) {
    $sourceDir = Join-Path $repoRoot $relativePath
    if (Test-Path -LiteralPath $sourceDir) {
        $destinationDir = Join-Path $TargetDir $relativePath
        Sync-ManagedDirectory -SourceDir $sourceDir -DestinationDir $destinationDir
    }
}

Write-Output "Synced context-infrastructure to $TargetDir"
