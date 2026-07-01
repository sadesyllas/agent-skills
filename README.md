# agent-skills

Two portable [Agent Skills](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
that establish a disciplined, spec-driven process for building software. They
work across **Claude Code**, **OpenAI Codex**, and **Google Antigravity** —
the skill format (`SKILL.md` + YAML frontmatter) is shared by all three; only
the install location differs.

## The flow

```
            ┌─────────────────────┐         ┌──────────────────────────┐
  start ──▶ │  spec-environment   │ ──────▶ │   spec-exec     │ ──▶ ship
            │  (the environment)  │ handoff │   (the execution)         │
            └─────────────────────┘         └──────────────────────────┘
```

1. **`spec-environment`** — runs once at project start. Interactively builds
   `SPEC.md` with you, derives an ordered `MILESTONES.md` with a
   Done/Tested/Reviewed tracking table, commits each, and hands off.
2. **`spec-exec`** — the engineering compass for building. Implements
   milestones strictly in order, commits every meaningful task, gates each
   milestone on Done + Tested, honors DRY and documentation rules, stops after
   each milestone to ask whether to continue, and runs the reviewer / `REVIEW.md`
   workflow.

There is **no `AGENTS.md`** — the rules live inside the skills themselves. Skills
load on demand rather than staying pinned to context, so `spec-exec`
re-anchors at the start of every milestone (re-reads `SPEC.md`/`MILESTONES.md`
and restates the rules) to stay reliable across long builds and context
compaction.

## Install

Symlink the skills into each tool's user-level skills directory. After a
`git pull`, every tool sees the update with no re-install.

```powershell
# Windows / PowerShell
pwsh ./install.ps1            # symlink (recommended)
pwsh ./install.ps1 -Copy      # copy instead, if symlinks are unavailable
```

```bash
# macOS / Linux / WSL
./install.sh                  # symlink (recommended)
./install.sh --copy           # copy instead
```

> **Windows symlinks** require Developer Mode (Settings → System → For
> developers) or an elevated shell. If linking fails, re-run with `-Copy`.

### Where they land (global install)

| Tool                       | User-level skills directory          |
|----------------------------|--------------------------------------|
| Claude Code                | `~/.claude/skills/`                  |
| OpenAI Codex               | `~/.codex/skills/`                   |
| Antigravity IDE / 2.0      | `~/.gemini/config/skills/`           |
| Antigravity CLI (global)   | `~/.gemini/antigravity-cli/skills/`  |
| Antigravity (shared)       | `~/.gemini/skills/`                  |

> **Antigravity caveat.** The IDE and the CLI currently read *different* global
> skill directories and the layout is still being standardized (see
> [gemini-cli#17495](https://github.com/google-gemini/gemini-cli/issues/17495)),
> so the installer writes to all known Antigravity candidates. If a future
> Antigravity build settles on one path, prune the list. **Plugins are not
> required** — Antigravity loads a standalone `SKILL.md` from any recognized
> skills directory; plugins are only an optional way to *bundle/distribute*
> skills, rules, MCP servers, and hooks.

### Per-project install (most reliable)

For a single project, install into its `.agents/skills/` (read natively by Codex
and Antigravity workspaces) and `.claude/skills/` (Claude Code):

```powershell
pwsh ./install.ps1 -Project C:\path\to\repo
```
```bash
./install.sh --project /path/to/repo
```

## Use

- Starting a project: invoke **`spec-environment`** (e.g. ask the agent to "set
  up the spec and milestones"). Build `SPEC.md` together, then let it generate
  `MILESTONES.md`.
- Building: invoke **`spec-exec`** ("start building" / "implement the
  next milestone"). It implements one milestone, then stops and asks before the
  next — unless you tell it to run several.
- Reviewing: ask it to "review the milestones". Findings go to `REVIEW.md`,
  which is deleted once everything under review passes and `Reviewed` is ticked.

## Repository layout

```
skills/
  spec-environment/          # SKILL 1 — bootstrap the environment
    SKILL.md
    assets/
      SPEC.template.md
      MILESTONES.template.md
  spec-exec/       # SKILL 2 — drive the build
    SKILL.md
    assets/
      REVIEW.template.md
install.ps1                  # symlink/copy into all three tools (Windows)
install.sh                   # symlink/copy into all three tools (POSIX)
```
