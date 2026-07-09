#!/usr/bin/env bash
# Install the skills in this repo into the skill directories of Claude Code,
# OpenAI Codex, Google Antigravity, OpenCode, Grok Build, and Cursor by symlinking
# each skill folder.
#
#   ./install.sh                     # global install (all tools, recommended)
#   ./install.sh --copy              # copy instead of symlink (if links unavailable)
#   ./install.sh --project /path     # project install into /path/.agents/skills + .grok/skills + .cursor/skills + ...
#   ./install.sh --project /path --copy
#
# Antigravity note: the IDE and CLI currently read DIFFERENT global skill dirs and
# the layout is still being standardized, so the global install targets all known
# candidates. The per-project .agents/skills route is the most reliable.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skills_root="$repo_root/skills"

mode="link"
project=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --copy) mode="copy"; shift ;;
        --project) project="${2:?--project needs a path}"; shift 2 ;;
        *) echo "unknown argument: $1" >&2; exit 1 ;;
    esac
done

if [[ -n "$project" ]]; then
    # Project scope: .agents/skills (shared/Codex/Antigravity), .grok/skills (Grok Build),
    # .cursor/skills (Cursor), .opencode/skills (OpenCode), and .claude/skills (Claude Code).
    project_root="$(cd "$project" && pwd)"
    targets=(
        "$project_root/.agents/skills"
        "$project_root/.grok/skills"
        "$project_root/.cursor/skills"
        "$project_root/.opencode/skills"
        "$project_root/.claude/skills"
    )
    echo "Installing into project: $project_root"
else
    # User-level (global) skill directories for each tool.
    targets=(
        "$HOME/.claude/skills"                  # Claude Code
        "$HOME/.codex/skills"                   # OpenAI Codex
        "$HOME/.gemini/config/skills"           # Antigravity IDE / 2.0
        "$HOME/.gemini/antigravity-cli/skills"  # Antigravity CLI (global)
        "$HOME/.gemini/skills"                  # Antigravity (shared across tools)
        "$HOME/.grok/skills"                    # Grok Build
        "$HOME/.cursor/skills"                  # Cursor
        "$HOME/.agents/skills"                  # Cursor / shared agents (global)
        "$HOME/.config/opencode/skills"         # OpenCode
    )
fi

count=0
for target in "${targets[@]}"; do
    mkdir -p "$target"
    for skill in "$skills_root"/*/; do
        name="$(basename "$skill")"
        link="$target/$name"
        rm -rf "$link"
        if [[ "$mode" == "copy" ]]; then
            cp -R "$skill" "$link"
            echo "copied  $name -> $link"
        else
            ln -s "$skill" "$link"
            echo "linked  $name -> $link"
        fi
        count=$((count + 1))
    done
done

echo ""
echo "Done. Installed skills into ${#targets[@]} director(ies) ($count link(s)/cop(ies))."
