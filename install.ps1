#!/usr/bin/env pwsh
# Install the skills in this repo into the skill directories of Claude Code,
# OpenAI Codex, Google Antigravity, and OpenCode by symlinking each skill folder.
#
#   pwsh ./install.ps1                       # global install (all tools, recommended)
#   pwsh ./install.ps1 -Copy                 # copy instead of symlink (if links unavailable)
#   pwsh ./install.ps1 -Project C:\repo      # project install into <repo>\.agents\skills + .claude\skills
#   pwsh ./install.ps1 -Project C:\repo -Copy
#
# Antigravity note: the IDE and CLI currently read DIFFERENT global skill dirs and
# the layout is still being standardized, so the global install targets all known
# candidates. The per-project .agents/skills route is the most reliable.
#
# Windows note: creating symlinks requires Developer Mode (Settings > System >
# For developers) or an elevated shell. If linking fails, re-run with -Copy.

[CmdletBinding()]
param(
    [switch]$Copy,
    [string]$Project
)

$ErrorActionPreference = 'Stop'

$skillsRoot = Join-Path $PSScriptRoot 'skills'
$skills = Get-ChildItem -Path $skillsRoot -Directory

if ($Project) {
    # Project scope: .agents/skills (Codex + Antigravity workspace), .opencode/skills (OpenCode), and .claude/skills (Claude Code).
    $projectRoot = (Resolve-Path $Project).Path
    $targets = @(
        (Join-Path $projectRoot '.agents/skills'),
        (Join-Path $projectRoot '.opencode/skills'),
        (Join-Path $projectRoot '.claude/skills')
    )
    Write-Host "Installing into project: $projectRoot"
}
else {
    # User-level (global) skill directories for each tool.
    $targets = @(
        (Join-Path $HOME '.claude/skills'),                 # Claude Code
        (Join-Path $HOME '.codex/skills'),                  # OpenAI Codex
        (Join-Path $HOME '.gemini/config/skills'),          # Antigravity IDE / 2.0
        (Join-Path $HOME '.gemini/antigravity-cli/skills'), # Antigravity CLI (global)
        (Join-Path $HOME '.gemini/skills'),                 # Antigravity (shared across tools)
        (Join-Path $HOME '.config/opencode/skills')         # OpenCode
    )
}

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
Write-Host "Done. Installed $($skills.Count) skill(s) into $($targets.Count) director(ies)."
