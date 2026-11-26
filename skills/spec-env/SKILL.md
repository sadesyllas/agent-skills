---
name: spec-env
description: 'Establish requirements and ordered milestones when the user requests project planning or substantial new work needs a plan. Produces SPEC.md and MILESTONES.md; does not implement or review code. Missing planning documents alone do not trigger this workflow for ordinary maintenance.'
---

# spec-env — plan the work

Own requirements and milestone planning. Implementation may begin only when
the user explicitly invokes `spec-exec` or `spec-iterate` by name for that work.
This applies equally to direct edits and delegated implementation. Plan approval
or a generic request to continue or build leaves you in the planning role.
Code review belongs to `spec-review`. Launch another agent only when requested.

## Choose the working branch

Before editing planning files, check the current branch and identify the
repository's default branch from Git metadata, such as the primary remote's
symbolic `HEAD`. If the default is unknown, treat conventional names such as
`main`, `master`, and `trunk` as defaults. When on the default branch, create
and switch to a new task branch unless the user explicitly directs you to stay
on the default branch. If Git needs initialization, treat the initial branch as
the default and apply the rule before the first commit.

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

Use the existing milestone for work needed to meet its agreed criteria, including
fixes from a review it has yet to pass. For a proposed change outside that scope,
settle where it belongs before editing the plan or implementing the change.

- Once a milestone has passed review, preserve its definition and tracking row.
  Create a new milestone with its own ID, criteria, verification, and status for
  subsequent changes to that work, even if they touch the same files.
- If the current milestone has yet to pass review, ask the user whether to
  include the change in it or create a new milestone. Wait for their answer.
  Honor a placement they already specified. If there is no current milestone,
  create a new one for the change.
- Only an explicit user instruction to make this particular change outside the
  milestone plan permits ad hoc implementation. Keep it outside the milestone
  records, including any milestone that has passed review.

Resolve missing requirements with the user and update `SPEC.md` when the
requirements change. Record the agreed milestone scope, criteria, and required
verification in `MILESTONES.md` before implementation. If the user expands an
unreviewed milestone, have the implementer reassess Done and Tested against the
revised criteria. Update Current work and commit planning changes separately.

## Hand off

Set Current work to the next action and briefly summarize the plan. For example,
“M0 is ready. Invoke `spec-exec` to implement and test it, or `spec-iterate`
to coordinate implementation and independent review.”

For an implementation handoff, stop until the user explicitly invokes
`spec-exec` or `spec-iterate` for this work. An invocation supplied with the
planning request still counts. Switch to and load the named skill before
implementation. Report a missing skill at handoff.
