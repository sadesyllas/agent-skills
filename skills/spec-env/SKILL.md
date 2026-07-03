---
name: spec-env
description: 'Bootstrap the engineering environment for a software project BEFORE any implementation begins. Use when starting a new library, application, or deployable PoC; when a repository has no SPEC.md yet; or when the user asks to "set up the spec", "plan the milestones", "prepare the project", or "bootstrap". Interactively builds SPEC.md with the user (purpose, components, dependencies, telemetry, integrations, auth, performance, testing, DRY, standards, documentation), generates an ordered MILESTONES.md with a Done/Tested/Reviewed tracking table, commits each artifact, and then hands off to the spec-exec skill to build.'
---

# spec-env — establish the environment before any code

This skill prepares the ground for building a software system (a library, an
application, a deployable PoC, etc.). **No implementation happens here.** The
output of this skill is two committed, agreed-upon documents — `SPEC.md` and
`MILESTONES.md` — and a clean handoff to the `spec-exec` skill.

## When to use / when not to

- **Use it** at the very start of a project, or whenever a repository does not
  yet have a complete `SPEC.md` and `MILESTONES.md`.
- **Do not use it** to write product code, fix bugs, or implement milestones —
  that is the job of `spec-exec`.
- If `SPEC.md` and `MILESTONES.md` already exist and the user wants to build,
  switch to `spec-exec` instead.

## The non-negotiable principle: spec before code

Nothing gets built until `SPEC.md` exists and the user has signed off on it.
The spec is the single source of truth; code conforms to the spec, never the
other way around. If reality forces a change, the spec changes **first** (see
the SPEC-change protocol below).

## Step 1 — Build `SPEC.md` interactively with the user

Create `SPEC.md` at the repository root. **Do not invent requirements.** Drive
this as an interview: propose a draft for each section, ask the user to confirm
or correct, and only record what is agreed. Use `assets/SPEC.template.md` in
this skill as the skeleton.

`SPEC.md` must **fully contain**:

1. **Purpose and structure** — what the project is for and how it is organized.
2. **Components** — the modules/services/projects and their responsibilities.
3. **Dependencies** — libraries, frameworks, runtimes, and external tooling.
4. **Telemetry** — how observability is produced (e.g. Serilog, OpenTelemetry,
   metrics, structured logs, traces) and where it is emitted.
5. **System interactions** — how the software talks to other systems (APIs,
   message buses, databases, third parties), including protocols and contracts.

`SPEC.md` must **explicitly state** (these are commitments, not suggestions):

1. **Authentication & authorization** — what is required and how it is enforced.
2. **Performance characteristics** — any latency, throughput, or resource
   targets that must be met.
3. **Full testing coverage** — the requirement that the system be thoroughly
   tested (unit, integration, contract as applicable).
4. **DRY** — the absolute requirement to honor Don't-Repeat-Yourself; no
   duplicated logic, boilerplate, or query patterns.
5. **Highest coding standards** — the requirement to uphold strong, idiomatic,
   maintainable code, as defined by the **`code-quality`** skill
   (documentation, DRY, one top-level type per file); `spec-exec` loads and
   enforces it during implementation.
6. **Mandatory documentation** — documentation is required, especially for
   public APIs and complex flows.

When every section is agreed, **commit** `SPEC.md` on its own (e.g.
`docs: add SPEC.md`). If the repository is not yet a git repo, initialize it
first.

## Step 2 — Generate `MILESTONES.md`

Only after `SPEC.md` is complete and committed, derive `MILESTONES.md` at the
repository root from it. Use `assets/MILESTONES.template.md` as the skeleton.

- Break the work into **very precise, ordered steps** that are implemented one
  after another. Each milestone must be small enough to implement, test, and
  review as a unit, and must have clear acceptance criteria and a defined set of
  required tests.
- Maintain a **tracking table** at the top with one row per milestone and three
  status columns, each holding a green tick (✅) once achieved and a blank
  marker (⬜) until then:
  - **Done** — the milestone has been implemented.
  - **Tested** — thorough tests have been written **and** they pass.
  - **Reviewed** — a reviewer has gone through the codebase and the milestone's
    changes have passed review.
- Below the table, give each milestone its own detail section (scope,
  acceptance criteria, required tests).

**Commit** `MILESTONES.md` on its own (e.g. `docs: add MILESTONES.md`).

## Step 3 — The SPEC-change protocol (applies forever after)

Whenever something in `SPEC.md` must change — during planning or later during
implementation — follow this order strictly:

1. **Update `SPEC.md` first.** Clearly state the shift in logic where the change
   is non-trivial, so the reasoning is captured, not just the new text.
2. **Reconcile `MILESTONES.md`** if the change affects scope, ordering, or
   acceptance criteria.
3. **Commit** the spec change on its own (e.g. `spec: change X because Y`).
4. **Only then** continue (or resume) implementation against the new spec.

Never let code drift ahead of the spec.

## Step 4 — Hand off to execution

Once `SPEC.md` and `MILESTONES.md` are committed:

1. Tell the user the environment is ready and summarize the milestone plan.
2. Instruct them (and yourself) to invoke the **`spec-exec`** skill to
   begin building — that skill enforces the engineering rules and drives the
   milestone-by-milestone loop. Explicit invocation is the most reliable handoff
   across tools; do not start coding under this skill.

## Assets

- `assets/SPEC.template.md` — skeleton for `SPEC.md`.
- `assets/MILESTONES.template.md` — skeleton for `MILESTONES.md`, including the
  Done/Tested/Reviewed tracking table.
