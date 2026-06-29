#!/usr/bin/env pwsh
# Install the skills in this repo into the skill directories of Claude Code,
# OpenAI Codex, and Google Antigravity by symlinking each skill folder.
#
#   pwsh ./install.ps1            # symlink (recommended; reflects future git pulls)
#   pwsh ./install.ps1 -Copy      # copy instead (use if symlinks are unavailable)
#
# Windows note: creating symlinks requires Developer Mode (Settings > System >
# For developers) or an elevated shell. If linking fails, re-run with -Copy.

[CmdletBinding()]
param(
    [switch]$Copy
)

$ErrorActionPreference = 'Stop'

$skillsRoot = Join-Path $PSScriptRoot 'skills'
$skills = Get-ChildItem -Path $skillsRoot -Directory

# User-level (global) skill directories for each tool.
$targets = @(
    (Join-Path $HOME '.claude/skills'),          # Claude Code
    (Join-Path $HOME '.codex/skills'),           # OpenAI Codex
    (Join-Path $HOME '.gemini/config/skills')    # Google Antigravity
)

foreach ($target in $targets) {
    if (-not (Test-Path $target)) {
        New-Item -ItemType Directory -Path $target -Force | Out-Null
    }
    foreach ($skill in $skills) {
        $link = Join-Path $target $skill.Name
        if (Test-Path $link) { Remove-Item $link -Recurse -Force }
        if ($Copy) {
            Copy-Item -Path $skill.FullName -Destination $link -Recurse
            Write-Host "copied  $($skill.Name) -> $link"
        }
        else {
            try {
                New-Item -ItemType SymbolicLink -Path $link -Target $skill.FullName -ErrorAction Stop | Out-Null
                Write-Host "linked  $($skill.Name) -> $link"
            }
            catch {
                Write-Warning "Could not symlink '$link'. Enable Windows Developer Mode or re-run with -Copy. ($($_.Exception.Message))"
            }
        }
    }
}

Write-Host ""
Write-Host "Done. Installed $($skills.Count) skill(s) into $($targets.Count) tool director(ies)."
