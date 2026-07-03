---
name: spec-exec
description: 'Drive disciplined, milestone-by-milestone implementation and review of a project that already has SPEC.md and MILESTONES.md. Use when the user says "start building", "implement the next milestone", "continue", "code this", or "review the milestones", and whenever writing or changing product code in a repo that has SPEC.md and MILESTONES.md. Enforces the engineering rules: conform to SPEC.md, follow milestones strictly in order, no untested code advances, commit at every step, uphold the code-quality skill (documentation, DRY, one type per file), and keep SPEC.md authoritative. Stops after each milestone to ask the user before continuing, and runs the reviewer / REVIEW.md workflow.'
---

# spec-exec — build the system, one milestone at a time

This is the engineering compass for implementation. It governs every change to
product code in a project that has a `SPEC.md` and a `MILESTONES.md`.

## Preconditions

- `SPEC.md` and `MILESTONES.md` must exist at the repository root. If either is
  missing or incomplete, **stop and use the `spec-env` skill first** —
  do not start coding against an absent or partial spec.

## Re-anchor at the start of every milestone (do this — it is what keeps the compass true)

Skills load on demand and context gets compacted over a long build, so these
rules will not stay resident on their own. Before working on **each** milestone,
re-anchor explicitly:

1. Re-read `SPEC.md` and `MILESTONES.md`.
2. **Load the `code-quality` skill** so its rules (documentation, DRY, one
   type per file, idiomatic code) are back in context.
3. State out loud which milestone you are starting and its acceptance criteria
   and required tests.
4. Restate the rules below — and the `code-quality` rules — as the active
   constraints for this milestone.

Treat this as mandatory, not optional. It is the mechanism that replaces an
always-in-context rules file.

## The rules

1. **Adhere to `SPEC.md`.** All code, configuration, and decisions must conform
   to the specification. If a task would require deviating from `SPEC.md`, stop
   and surface the conflict — do not improvise. Resolve it via the SPEC-change
   protocol (below) before continuing.

2. **Follow `MILESTONES.md` strictly, in order.** Work on milestone `Mn+1` only
   after `Mn` is complete. No skipping, reordering, or parallel work across
   milestones. Always state which milestone a change belongs to before starting.

3. **A milestone is complete only when it is both `Done` and `Tested`.** Meet the
   acceptance criteria **and** make the required tests pass before ticking the
   `Done` and `Tested` columns (✅). Do not begin the next milestone until both
   are ticked for the current one. (`Reviewed` is handled separately — see the
   reviewer workflow — and may lag.)

4. **No untested code advances.** Run the tests defined for the current milestone
   (unit, integration, contract as applicable) and confirm they are green before
   declaring it complete. Report failures honestly with their output; never mark
   `Tested` on red or skipped tests.

5. **Commit at every step.** Create a git commit for **each meaningful task**
   along the way — not just one per milestone. Each commit is focused, has a
   clear message that references its milestone (e.g. `M2: add rate-limiter
   middleware`), and leaves the repository buildable. Never commit secrets.

6. **Apply the `code-quality` skill to all production code.** Load that
   skill and treat its rules — document all types and public members, honor DRY
   absolutely, one top-level type definition per file, uphold idiomatic
   maintainable code — as mandatory constraints for every change made under
   this skill. Reviewers check against them too.

7. **Keep `SPEC.md` up to date.** Any change to architecture, endpoints,
   validation, configuration, or core features is reflected in `SPEC.md`
   immediately and accurately. Never let code drift from the spec.

## The milestone loop (coder)

For the current milestone:

1. **Re-anchor** (see above).
2. **Implement** the acceptance criteria, committing each meaningful task as you
   go (rule 5). Keep the build green.
3. **Test.** Write the required thorough tests and run them. They must pass.
4. **Mark progress.** Tick `Done` and `Tested` (✅) for the milestone in the
   `MILESTONES.md` table, and commit that change.
5. **Stop and ask.** Unless the user has explicitly told you to run multiple
   milestones (e.g. "do them all", "don't stop between milestones"), **halt here
   and ask the user whether to continue to the next milestone or stop for now.**
   Do not roll into `Mn+1` on your own.

## The reviewer workflow

A reviewer (model or human) goes through one or more milestones. For the
milestones under review:

- **If they pass:** tick the `Reviewed` column (✅) for each, and commit.
- **If there are problems:** create a `REVIEW.md` at the repository root that
  clearly describes each problem, where it is, and concrete guidance to fix it,
  grouped by milestone. Leave `Reviewed` un-ticked for the affected milestones.

Then the coder addresses every item in `REVIEW.md`, committing fixes (referencing
the milestone, e.g. `M3: fix N+1 query flagged in review`), and the reviewer
re-checks. Iterate until clean.

- **Closing the review:** once all milestones under review pass and their
  `Reviewed` columns are ticked, **delete `REVIEW.md`** (and commit its removal).
  `REVIEW.md` exists only while there are open review findings; its absence means
  there is nothing outstanding.

## SPEC-change protocol

If implementation reveals that `SPEC.md` must change, change the spec **first**:
update `SPEC.md` (stating the shift in logic for non-trivial changes), reconcile
`MILESTONES.md`, commit the spec change on its own, and only then resume coding.
This mirrors the protocol owned by the `spec-env` skill.

## Honesty and safety

- Report outcomes faithfully: if tests fail, say so with the output; if a step
  was skipped, say so.
- Keep the repository buildable at every commit.
- Never commit secrets, credentials, tokens, or keys.
