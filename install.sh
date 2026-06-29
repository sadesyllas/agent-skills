#!/usr/bin/env bash
# Install the skills in this repo into the skill directories of Claude Code,
# OpenAI Codex, and Google Antigravity by symlinking each skill folder.
#
#   ./install.sh            # symlink (recommended; reflects future git pulls)
#   ./install.sh --copy     # copy instead (use if symlinks are unavailable)
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skills_root="$repo_root/skills"

mode="link"
if [[ "${1:-}" == "--copy" ]]; then mode="copy"; fi

# User-level (global) skill directories for each tool.
targets=(
    "$HOME/.claude/skills"          # Claude Code
    "$HOME/.codex/skills"           # OpenAI Codex
    "$HOME/.gemini/config/skills"   # Google Antigravity
)

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
echo "Done. Installed skills into ${#targets[@]} tool director(ies) ($count link(s)/cop(ies))."
