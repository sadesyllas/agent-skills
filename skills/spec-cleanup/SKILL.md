---
name: spec-cleanup
description: Clean up a spec-driven iteration when the user asks to retire its planning files or finish its Git branch. Ask which optional cleanup actions to take.
---

# spec-cleanup — clean up an iteration

Requesting cleanup authorizes removal of the iteration's root `SPEC.md` and
`MILESTONES.md` by default. Honor any changes the user specifies at invocation.
For example, “only remove the planning files” skips the optional questions.

## Identify the iteration

Read the available planning files, handoff, and Git state. For a normal wrap-up,
check that all planned milestones passed implementation, testing, and review,
`REVIEW.md` is absent, and any AFK decisions were reviewed and amendments
resolved. If work is still open, tell the user what would be retired and ask
how to proceed. Honor a clear request to abandon or otherwise close that work.
`REVIEW.md` belongs to the reviewer. If wrap-up already removed planning files,
skip those paths and continue with the remaining requested cleanup.

Before switching branches, identify the iteration branch and commit range,
the default branch from repository or remote metadata, and any corresponding
remote iteration branch. Check for staged or uncommitted work and other
worktrees. If a target or range is ambiguous, clarify it before the affected
Git operation. On the default branch or a detached HEAD, there is no current
task branch to delete.

## Ask for the optional actions

Ask the applicable, unanswered questions together. Name the actual paths,
branches, and remote so the user can answer each independently.

- **Decision ledger.** If this was an AFK (silent or non-interactive) iteration
  and its ledger exists, ask “Delete `DECISIONS.md`?” Use the actual ledger
  path if the user designated another. Establish its origin from the run or
  file history. A matching filename alone is insufficient.
- **Squash.** “Squash this iteration's commits into one commit?”
- **Land.** “Land the iteration on `<default-branch>`?” Use an explicitly
  requested destination if supplied. Say whether the proposed landing updates
  a local branch or publishes to a named remote through the project's workflow.
- **Delete locally.** “Delete the local iteration branch `<branch>`?”
- **Delete remotely.** If the remote branch exists, ask “Delete the branch
  `<branch>` on `<remote>`?” Use its actual remote name even if the local
  branch has a different name.

Wait for an explicit yes, OK, or equally clear instruction for **each** optional
action before taking it. Credit choices already made in the invocation.
An explicit “yes to all” covers all listed choices.
A partial answer covers only the choices it identifies. Leave ambiguous answers
pending. AFK mode and a generic cleanup request supply no optional approvals.

## Apply and verify

1. Remove the planning files that are present and any approved ledger. Record
   tracked removals in a focused commit unless the user requested otherwise.
   Preserve unrelated files and staged changes.
2. Apply the approved history choices independently. Squash and land together
   can produce one commit on the target. Squash alone affects only the
   iteration's commits on its branch. Landing alone preserves the commits.
   Limit changes to the agreed range and destination. A published history
   rewrite requires explicit authorization for that remote update.
3. Verify the resulting commit and content before deleting branches. Switch
   off the iteration branch before local deletion. Delete only the approved
   local or remote iteration refs, and protect the default and landing branches.
   If deletion would discard unlanded work, identify what would be lost and
   obtain explicit agreement to discard it. If landing fails or a ref has
   advanced since inspection, pause dependent deletions and reassess.

Report the files removed, the resulting branch and commit when applicable,
and the verified disposition of each local and remote branch in scope.
