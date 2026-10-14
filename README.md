# agent-skills

Portable [Agent Skills](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
that establish a disciplined, spec-driven process for building software. They
work across **Claude Code**, **OpenAI Codex**, **Google Antigravity**, **OpenCode**,
**Grok Build**, and **Cursor** — the skill format (`SKILL.md` + YAML frontmatter)
is shared by all of them; only the install location differs.

## The flow

```text
spec-env → spec-exec → spec-review
              ↑           │
              └── fixes ──┘
```

| Skill | Responsibility |
|-------|----------------|
| `spec-env` | Establish agreed requirements and ordered milestones; ask about missing requirements. |
| `spec-exec` | Implement, test, and fix findings; maintain Done and Tested. |
| `spec-review` | Review changes and verify fixes; own REVIEW.md and Reviewed. |
| `spec-iterate` | Manually orchestrate sequential implementer and reviewer sub-agents across selected milestones. |
| `code-quality` | Shared coding standards, including mandatory DRY for production logic. |

Roles hand off explicitly and stop at their boundary unless the user has asked
for the next role too. After implementation, the agent says the milestone is
ready for review. Asking for a review invokes `spec-review`; the implementer does
not silently become the reviewer. No additional agents are launched unless asked.
Explicitly invoking `spec-iterate` requests that orchestration: after planning,
it delegates each implementation and review step for one milestone at a time.

`SPEC.md` and Git are the sources of truth for requirements, implementation, and
history. `MILESTONES.md` holds the plan, the existing Done/Tested/Reviewed table,
and one short **Current work** block: Milestone, Next action, Blocker, Verification.
Each role replaces stale values at meaningful changes and handoffs. New sessions
check the block against the spec and actual code before resuming. `REVIEW.md`
contains findings while review is open; its absence alone does not prove review
occurred.

There is **no `AGENTS.md`** — shared workflow rules live in the skills. Agents
read relevant instructions and project state when starting or resuming, and
report actions and results without reciting the rules. Git retains history;
project documents describe the current state.

## Install

Symlink the skills into each tool's user-level skills directory. After a
`git pull`, every supported tool (Claude Code, Codex, Antigravity, OpenCode,
Grok Build, Cursor) sees the update with no re-install.

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

> After installing for Grok Build or Cursor, the skills become available as
> slash commands (e.g. `/spec-env`) and for automatic invocation when the
> description matches the task. Grok and Cursor both discover skills in the
> documented native paths plus compatibility locations.
> `spec-iterate` is manual-only; its instructions require explicit invocation,
> and its Codex metadata disables implicit invocation.

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
| Grok Build                 | `~/.grok/skills/`                    |
| Cursor                     | `~/.cursor/skills/`                  |
| Cursor / shared agents     | `~/.agents/skills/`                  |
| OpenCode                   | `~/.config/opencode/skills/`         |

> **Antigravity caveat.** The IDE and the CLI currently read *different* global
> skill directories and the layout is still being standardized (see
> [gemini-cli#17495](https://github.com/google-gemini/gemini-cli/issues/17495)),
> so the installer writes to all known Antigravity candidates. If a future
> Antigravity build settles on one path, prune the list. **Plugins are not
> required** — Antigravity loads a standalone `SKILL.md` from any recognized
> skills directory; plugins are only an optional way to *bundle/distribute*
> skills, rules, MCP servers, and hooks.

### Per-project install (most reliable)

For a single project, install into its `.agents/skills/` (shared, Codex,
Antigravity), `.grok/skills/` (Grok Build), `.cursor/skills/` (Cursor),
`.opencode/skills/` (OpenCode), and `.claude/skills/` (Claude Code):

```powershell
pwsh ./install.ps1 -Project C:\path\to\repo
```
```bash
./install.sh --project /path/to/repo
```

## Use

- Starting a project: invoke **`spec-env`** (e.g. ask the agent to "set
  up the spec and milestones"). Agree on `SPEC.md`, then derive `MILESTONES.md`.
  Missing planning files alone do not require this workflow for routine fixes.
- Building: invoke **`spec-exec`** ("start building" / "implement the
  next milestone"). It implements and tests one milestone, then hands off to
  review — unless you tell it to continue implementation across several.
- Reviewing: invoke **`spec-review`** or ask to "review the milestones".
  Findings go to `REVIEW.md`; fixes return to `spec-exec`. Ask for re-review
  when fixes are ready. Only the reviewer verifies closure and removes the file
  after all its findings are resolved and affected milestones pass review.
- Changing roles: explicitly request a combined workflow if desired, such as
  "implement M1, then review it". Otherwise each role stops at its handoff.
- Iterating: explicitly invoke **`spec-iterate`** after `spec-env` has established
  the planning artifacts. It checks current progress through a read-only agent,
  asks separately for implementer and reviewer models and thinking efforts, then
  asks for **All** remaining milestones or a specific inclusive range. It uses
  one sub-agent executing at a time and completes implementation and review of
  each milestone before advancing. Each milestone uses a fresh implementer and
  separate reviewer, reused within that milestone's implementation, review, and
  fix cycles; each assignment checks the current project artifacts and code.
  Workers are never reused across milestones. If the initial implementation and
  first fix both fail review, the latest reviewer continues with `spec-exec` to
  fix the milestone, and a fresh reviewer verifies the result. This requires a
  host with sub-agent model/effort selection.

## Repository layout

```
skills/
  spec-env/                   # requirements and milestone planning
    SKILL.md
    assets/
      SPEC.template.md
      MILESTONES.template.md
  spec-exec/                  # implementation, tests, and fixes
    SKILL.md
  spec-review/                # review and verification of fixes
    SKILL.md
    assets/
      REVIEW.template.md
  spec-iterate/               # manual orchestration of sequential sub-agents
    SKILL.md
    agents/
      openai.yaml             # disables implicit invocation in Codex
  code-quality/               # shared implementation and review standards
    SKILL.md
install.ps1                   # symlink/copy into supported tools (Windows)
install.sh                    # symlink/copy into supported tools (POSIX)
```
