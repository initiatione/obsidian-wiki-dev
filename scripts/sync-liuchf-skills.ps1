[CmdletBinding()]
param(
    [switch]$Apply,
    [string]$RepoRoot,
    [string]$CompanionRoot,
    [string[]]$TargetRoots = @(
        (Join-Path $env:USERPROFILE ".codex\skills"),
        (Join-Path $env:USERPROFILE ".claude\skills")
    ),
    [string[]]$ExcludeSkills = @(
        "hermes-history-ingest",
        "openclaw-history-ingest",
        "copilot-history-ingest",
        "pi-history-ingest"
    ),
    [string[]]$SkillNames,
    [string[]]$CompanionSkillNames = @(
        "obsidian-markdown",
        "obsidian-bases",
        "json-canvas",
        "obsidian-cli",
        "defuddle"
    ),
    [switch]$SkipCompanionSkills
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-NormalizedPath {
    param([Parameter(Mandatory)][string]$Path)
    $expanded = [Environment]::ExpandEnvironmentVariables($Path)
    return [System.IO.Path]::GetFullPath($expanded).TrimEnd("\", "/")
}

function Test-PathWithin {
    param(
        [Parameter(Mandatory)][string]$Child,
        [Parameter(Mandatory)][string]$Parent
    )
    $childPath = Get-NormalizedPath $Child
    $parentPath = Get-NormalizedPath $Parent
    return $childPath.Equals($parentPath, [StringComparison]::OrdinalIgnoreCase) -or
        $childPath.StartsWith($parentPath + [System.IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)
}

function New-UniqueBackupPath {
    param(
        [Parameter(Mandatory)][string]$BackupDir,
        [Parameter(Mandatory)][string]$Name
    )
    $candidate = Join-Path $BackupDir $Name
    if (-not (Test-Path -LiteralPath $candidate)) {
        return $candidate
    }

    $i = 1
    while ($true) {
        $next = Join-Path $BackupDir ("{0}.{1}" -f $Name, $i)
        if (-not (Test-Path -LiteralPath $next)) {
            return $next
        }
        $i++
    }
}

function Get-LinkTarget {
    param([Parameter(Mandatory)]$Item)
    if ($null -eq $Item.PSObject.Properties["Target"]) {
        return $null
    }
    $target = $Item.Target
    if ($target -is [array]) {
        return ($target | Select-Object -First 1)
    }
    return $target
}

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = Split-Path -Parent $PSScriptRoot
}

$repoRootPath = Get-NormalizedPath $RepoRoot
$sourceRoot = Join-Path $repoRootPath ".skills"
if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) {
    throw "Skill source directory not found: $sourceRoot"
}

if (-not $SkillNames -or $SkillNames.Count -eq 0) {
    $SkillNames = Get-ChildItem -LiteralPath $sourceRoot -Directory |
        Where-Object {
            (Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")) -and
            ($ExcludeSkills -notcontains $_.Name)
        } |
        Sort-Object Name |
        Select-Object -ExpandProperty Name
}

$skillLinks = @()
foreach ($skill in ($SkillNames | Sort-Object -Unique)) {
    $skillLinks += [pscustomobject]@{
        Name = $skill
        Source = Join-Path $sourceRoot $skill
        Origin = "wiki"
    }
}

if (-not $SkipCompanionSkills) {
    if ([string]::IsNullOrWhiteSpace($CompanionRoot)) {
        $CompanionRoot = Join-Path (Split-Path -Parent $repoRootPath) "obsidian-skills\skills"
    }

    $companionRootPath = Get-NormalizedPath $CompanionRoot
    if (Test-Path -LiteralPath $companionRootPath -PathType Container) {
        foreach ($skill in ($CompanionSkillNames | Sort-Object -Unique)) {
            $skillLinks += [pscustomobject]@{
                Name = $skill
                Source = Join-Path $companionRootPath $skill
                Origin = "companion"
            }
        }
    }
    else {
        Write-Warning "Companion skill root not found, skipping companion skills: $companionRootPath"
    }
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$mode = if ($Apply) { "APPLY" } else { "DRY-RUN" }
Write-Host "Mode: $mode"
Write-Host "Repo: $repoRootPath"
Write-Host "Wiki skills: $($SkillNames -join ', ')"
if (-not $SkipCompanionSkills -and (Test-Path -LiteralPath (Get-NormalizedPath $CompanionRoot) -PathType Container)) {
    Write-Host "Companion root: $(Get-NormalizedPath $CompanionRoot)"
    Write-Host "Companion skills: $($CompanionSkillNames -join ', ')"
}

foreach ($targetRootRaw in $TargetRoots) {
    $targetRoot = Get-NormalizedPath $targetRootRaw
    $targetParent = Split-Path -Parent $targetRoot
    $backupRoot = Join-Path $targetParent "skills-backup"
    $backupDir = Join-Path $backupRoot $timestamp

    Write-Host ""
    Write-Host "Target: $targetRoot"

    if ($Apply) {
        if (-not (Test-Path -LiteralPath $targetRoot)) {
            New-Item -ItemType Directory -Path $targetRoot | Out-Null
        }
    }

    foreach ($skillLink in $skillLinks) {
        $skill = $skillLink.Name
        $source = $skillLink.Source
        $origin = $skillLink.Origin
        $dest = Join-Path $targetRoot $skill

        if (-not (Test-Path -LiteralPath $source -PathType Container)) {
            Write-Warning "Skip missing $origin source skill: $skill"
            continue
        }

        if (-not (Test-PathWithin -Child $dest -Parent $targetRoot)) {
            throw "Refusing to touch path outside target root: $dest"
        }

        $action = "create-junction"
        if (Test-Path -LiteralPath $dest) {
            $item = Get-Item -LiteralPath $dest -Force
            $linkType = $item.LinkType
            if ($linkType) {
                $existingTarget = Get-LinkTarget $item
                if ($existingTarget -and ((Get-NormalizedPath $existingTarget).Equals((Get-NormalizedPath $source), [StringComparison]::OrdinalIgnoreCase))) {
                    Write-Host ("  OK      [{0}] {1} -> {2}" -f $origin, $skill, $source)
                    continue
                }
                $action = "replace-link"
            }
            else {
                $action = "backup-and-replace"
            }
        }

        if (-not $Apply) {
            Write-Host ("  WOULD   [{0}] {1}: {2} -> {3}" -f $origin, $action, $dest, $source)
            continue
        }

        if (Test-Path -LiteralPath $dest) {
            $item = Get-Item -LiteralPath $dest -Force
            if ($item.LinkType) {
                Remove-Item -LiteralPath $dest -Force
            }
            else {
                if (-not (Test-Path -LiteralPath $backupDir)) {
                    New-Item -ItemType Directory -Path $backupDir | Out-Null
                }
                $backupPath = New-UniqueBackupPath -BackupDir $backupDir -Name $skill
                if (-not (Test-PathWithin -Child $backupPath -Parent $backupRoot)) {
                    throw "Refusing to move backup outside backup root: $backupPath"
                }
                Move-Item -LiteralPath $dest -Destination $backupPath
                Write-Host ("  BACKUP  {0} -> {1}" -f $dest, $backupPath)
            }
        }

        New-Item -ItemType Junction -Path $dest -Target $source | Out-Null
        Write-Host ("  LINK    [{0}] {1} -> {2}" -f $origin, $dest, $source)
    }
}

Write-Host ""
if ($Apply) {
    Write-Host "Done. Junction sync applied."
}
else {
    Write-Host "Dry-run complete. Re-run with -Apply to create/update junctions."
}
