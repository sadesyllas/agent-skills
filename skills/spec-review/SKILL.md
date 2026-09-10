---
name: spec-review
description: 'Review code in projects using SPEC.md and MILESTONES.md when the user asks for a review, reviews milestones, or requests re-review of fixes. Checks shared code-quality standards and owns REVIEW.md and Reviewed; does not implement fixes.'
---

# spec-review — review the work

Own review findings and verification of their closure. `spec-env` owns planning;
`spec-exec` implements, tests, and fixes findings. Do not switch roles or launch
another agent unless the user asks. Follow explicit user changes to these
boundaries, and make any requested role switch clear.

## Start or resume

Read `SPEC.md`, the relevant `MILESTONES.md` sections and Current work, existing
`REVIEW.md`, and the actual working tree and Git changes. Load `code-quality`.
Establish the requested review scope from the user and handoff; ask if unclear.
Do not assume a clean working tree or that a previous tick covers later changes.

`SPEC.md` and Git are authoritative. Current work is a replaceable resumption
aid: reconcile stale notes against the actual files before proceeding. If an
omission or conflict leaves a requirement unclear, ask the user. Use the change
protocol in `spec-env` for agreed requirement changes before affected fixes;
do not invent requirements during review.

## Review and record findings

1. Check the requested changes and relevant surrounding code against the spec,
   acceptance criteria, required verification, and `code-quality`. Check reported
   verification evidence and run targeted checks needed to assess correctness.
2. Clear Reviewed for milestones being re-reviewed after relevant changes. Mark
   Reviewed only when the whole milestone passes and required verification is
   satisfied; a narrow review alone does not approve an entire milestone.
   An unavailable required check is a blocker, not a pass.
3. For actionable problems, create or update `REVIEW.md` using
   [assets/REVIEW.template.md](assets/REVIEW.template.md). Give each finding a
   stable ID, milestone, location, concrete problem and impact, and a verifiable
   resolution. Keep findings concise; avoid speculative issues or style demands
   unsupported by the applicable standards.
4. For repeated findings, replace stale evidence and guidance. Explain briefly
   why the attempted fix was insufficient and what would demonstrate resolution;
   do not append a history of review conversations.
5. Commit review-owned changes in a focused commit. Do not change product code,
   mark implementation Done/Tested, or implement findings under this role.

## Maintain Current work and hand off

Maintain the single Current work block: Milestone, Next action, Blocker, and
Verification. If missing, add only this block from verified project state.
Keep each field short, replace stale values when
meaningful state changes, and update before pausing or handing off. Record the
latest relevant check and result, including unavailable checks. Use links to
findings instead of copying them into the block. Do not add session logs or
tracking columns. Any role may maintain this block within its scope; table
ownership remains separate.

If fixes are needed, name `spec-exec` in Next action and briefly hand off the
findings: “Review found issues in M<n>. Ask spec-exec to fix the findings in
REVIEW.md, then request re-review.” Stop unless the user already requested the implementation
role as well; load `spec-exec` before an authorized switch. Report a missing
dependent skill rather than silently assuming its role.

## Verify fixes and close

On re-review, inspect the actual fixes and relevant verification; a coder's
report alone does not close a finding. Only the reviewer resolves findings,
marks Reviewed, or deletes and commits removal of `REVIEW.md`. Preserve findings
outside the current review scope. Delete the file only when all its findings
are resolved and their affected milestones have passed review.

The absence of `REVIEW.md` means no findings file is present; it does not prove
review occurred. The Reviewed table and Git history record completed review
passes, which do not certify later changes.

After a clean review, update Current work to the next required review or
implementation action, preserving pending work outside the reviewed scope.
Use `None — complete` only when all planned implementation and review are finished.
Briefly report scope, result, and limitations. Do not start the next role unless
the user has requested it.
