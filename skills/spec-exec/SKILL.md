---
name: spec-exec
description: 'Implement and test ordered milestones in a project with SPEC.md and MILESTONES.md, or fix findings from spec-review. Use for requested implementation in this workflow. Hands off to spec-review for review; does not review or close its own findings.'
---

# spec-exec — implement the work

Own implementation, tests, and fixes. `spec-env` owns requirements and planning;
`spec-review` owns review findings and closure. Do not switch roles or launch
another agent unless the user asks. Follow explicit user changes to these
boundaries, and make any requested role switch clear.

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

- Follow milestone order unless the user changes it. Advance only after the
  current milestone meets its acceptance criteria and required verification.
- Conform to `SPEC.md`. If requirements need to change, follow “Change an
  established specification” in `spec-env` before affected implementation.
- Apply `code-quality` to production code and use meaningful tests for the
  required behavior. Existing tests may suffice if they verify the change.
- Commit each meaningful task in a focused, buildable commit with its milestone
  in the message. Stage only relevant files; never include secrets.
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
the milestone definitions and reviewer-owned Reviewed column. Existing ticks
record completed passes; they do not certify later changes. If modifying already
reviewed work, state that renewed review is needed in Current work and the handoff.

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

Read `REVIEW.md`, implement the requested fixes, and rerun relevant verification.
If a finding conflicts with the spec or lacks needed information, ask before
guessing a resolution. Commit fixes referencing their milestone and finding.
Update Current work and hand back to `spec-review` for verification.

The implementer must not edit `REVIEW.md`, resolve findings, change Reviewed,
or delete or commit removal of the review file. A fix is ready for re-review;
only reviewer verification closes it unless the user explicitly changes roles.
