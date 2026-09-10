---
name: spec-env
description: 'Establish requirements and ordered milestones when the user requests project planning or substantial new work needs a plan. Produces SPEC.md and MILESTONES.md; does not implement or review code. Missing planning documents alone do not trigger this workflow for ordinary maintenance.'
---

# spec-env — plan the work

Own requirements and milestone planning. Implementation belongs to `spec-exec`;
code review belongs to `spec-review`. Do not switch roles or launch another agent
unless the user asks. Follow explicit user changes to these role boundaries.

## Establish the specification

1. Read the request, existing project documents, and relevant code and Git state.
   Reuse established requirements instead of restarting planning.
2. **Do not invent requirements.** Draft from known information. When input is
   needed, ask the user, including when an omission could hide a requirement.
   Do not treat silence as agreement or fill gaps with plausible requirements.
   Leave unresolved questions visibly pending and continue only independent work.
3. Use [assets/SPEC.template.md](assets/SPEC.template.md) to draft `SPEC.md`.
   Ask about missing behavior, constraints, or acceptance criteria before
   finalizing affected sections. A section may be omitted or marked not applicable
   only when known scope or the user's answer supports that decision.
4. Present the draft for agreement, resolving outstanding questions. Existing
   explicit approval still applies; do not repeat questions already answered.
5. Commit the agreed `SPEC.md` separately. Initialize Git if needed.

`SPEC.md` defines the current requirements and important design decisions. Git
records implementation and history. Keep both authoritative; derived progress
notes never override them. Keep rationale beside the relevant current decision,
and use Git history instead of an appended changelog.

Reference `code-quality` for shared engineering rules; do not copy its rules into
the specification. Record project-specific conventions and exceptions explicitly.

## Plan milestones and initialize current work

Derive `MILESTONES.md` using
[assets/MILESTONES.template.md](assets/MILESTONES.template.md). Keep milestones
small and ordered, with scope, observable acceptance criteria, and required
verification. Preserve the human-readable Done / Tested / Reviewed table:

- **Done:** acceptance criteria implemented; maintained by the implementer.
- **Tested:** required verification passes; maintained by the implementer.
- **Reviewed:** changes passed `spec-review`; maintained by the reviewer.

The default execution order requires Done and Tested before the next milestone.
Reviewed may lag when the user requests continued implementation.

Initialize the single **Current work** block above the table:

- **Milestone:** the active or next milestone, or `None — complete`.
- **Next action:** one concrete action, naming the next role when handing off.
- **Blocker:** the unresolved question or obstacle, or `None`.
- **Verification:** the latest relevant command/check and result, or `Not run`.

This block is a replaceable snapshot, not a log or another source of truth.
Keep each field short; use a file link for detail. Update it when the active work,
next action, blocker, or verification changes, and before pausing or handing off.
Any active role may update this block within its scope. Preserve other roles'
table ownership. On resumption, check the block against `SPEC.md`, Git, and actual
files; correct stale notes before using them. Do not add session journals,
revision columns, or duplicate status sections.

Commit `MILESTONES.md` separately after checking it against the agreed spec.

## Change an established specification

When the user requests a requirement change, or implementation or review reveals
a conflict, resolve any missing input with the user first. Update `SPEC.md` before
affected implementation, keeping concise rationale for non-trivial decisions.
Reconcile affected milestone scope, criteria, verification, and Current work;
commit the planning change separately, then hand back to the requested role.
Routine implementation details within the agreed requirements need no new
requirement or repeated approval.

## Hand off

Set Current work to the first implementation action and briefly summarize the
plan. Explain the dependency chain: `spec-exec` implements and tests, then hands
off to `spec-review`; only that reviewer verifies closure and marks Reviewed.
For example: “Planning is ready. Use spec-exec to implement M0. After testing,
the implementer will hand off; ask for a review to invoke spec-review.”

Stop at the planning boundary unless the user has already requested the next
role as well. If so, explicitly switch to and load that skill. If a required
skill is unavailable, report it rather than silently assuming its role.
