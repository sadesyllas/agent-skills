---
name: spec-exec
description: 'Implement and test agreed milestones in a project with SPEC.md and MILESTONES.md, including fixes for open review findings. Hands off to spec-review for independent review.'
---

# spec-exec — implement the work

Own implementation, tests, and fixes. Use `spec-env` for the planning updates
called for below. Other role switches and agent launches require a user request.
`spec-review` owns review findings and closure.
At a handoff from `spec-env`, start implementation only if the user explicitly
invoked `spec-exec` or `spec-iterate` for this work.

## Start or resume

1. Read `SPEC.md`, the relevant milestones and Current work in `MILESTONES.md`,
   any `REVIEW.md`, and the actual working tree and Git state. If necessary
   planning is missing or incomplete, use `spec-env` to resolve it before the
   affected implementation; do not invent requirements.
2. Load `code-quality`. Re-read relevant instructions after losing context or
   when they change; do not recite the rules at each milestone.
3. Reconcile stale Current work notes with the specification and actual code.
   Treat `SPEC.md` and Git as authoritative, not the progress snapshot.
4. Briefly state the milestone and next action. If input is needed, ask the
   user; an omitted requirement is not permission to guess. Continue only work
   that does not depend on the answer.

## Implement and verify

- Before editing, check that the work fits the assigned milestone's agreed
  name, description, and scope and is needed to meet its acceptance criteria.
  For a mismatch or additional work, follow the
  [milestone change rules](../spec-env/SKILL.md#change-an-established-specification).
  Use `spec-env` to record the agreed placement before starting the change.
- Work outside the milestone plan only if the user explicitly requests that
  for the specific change. Keep its commit separate from milestone work and
  preserve every reviewed milestone's definition and status.
- Follow milestone order unless the user changes it. Advance only after the
  current milestone meets its acceptance criteria and required verification.
- Conform to `SPEC.md`. If requirements need to change, follow “Change an
  established specification” in `spec-env` before affected implementation.
- Apply `code-quality` to production code and use meaningful tests for the
  required behavior. Existing tests may suffice if they verify the change.
- Commit each meaningful task in a focused, buildable commit. Reference its
  milestone in the message when it has one. Stage only relevant files; never
  include secrets.
- Run required verification. Record Done and Tested only when their respective
  conditions hold. Failed, skipped, or unavailable required checks do not pass.
  Commit progress updates with the relevant work or in a focused progress commit.

## Maintain Current work

Use the single four-field block in `MILESTONES.md`; if missing, add only this block
from verified project state. Do not add a journal or extra tracking columns.
Keep Milestone, Next action, Blocker, and Verification short
and current. Replace the previous values when meaningful state changes, and
before pausing or handing off. Name the next role in Next action when appropriate.
Record the latest relevant check and result; if later edits invalidate that
result, say verification needs rerunning. Do not copy logs into the block.

The block is a resumption aid. Read and check it on every new session. Preserve
the reviewer-owned Reviewed column. When the user expands an unreviewed
milestone, update Done and Tested to reflect the revised criteria and verification.

## Hand off to review

After implementing and testing a milestone, set Next action to
“Reviewer: review M<n> with spec-review” and summarize what changed, verification,
and any remaining limitations. Say clearly: “M<n> is implemented and tested.
It is ready for the reviewer; ask for a review to invoke spec-review.”

Stop here by default. Do not mark Reviewed or start reviewing automatically.
If the user already requested review as well, explicitly switch to `spec-review`
and load it. If the user requested multiple milestones or continued implementation,
continue within that scope and hand off the completed milestones together; review
remains pending. If `spec-review` is unavailable, report the missing dependency.

## Fix review findings

Read `REVIEW.md`. Fix findings against the agreed criteria of a milestone that
has yet to pass review or the scope of an explicitly authorized ad hoc change.
Rerun relevant verification. Route new scope or a finding about work that
already passed milestone review through the milestone change rules. If a
finding conflicts with the spec or lacks needed information, ask before
guessing a resolution. Reference the finding and its milestone, if any, in the commit.
Update Current work and hand back to `spec-review` for verification.

The implementer must not edit `REVIEW.md`, resolve findings, change Reviewed,
or delete or commit removal of the review file. A fix is ready for re-review;
only reviewer verification closes it unless the user explicitly changes roles.
