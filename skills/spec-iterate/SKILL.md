---
name: spec-iterate
description: 'Orchestrate spec-exec and spec-review sub-agents through a selected milestone range. Use only when the user explicitly invokes spec-iterate; requires existing spec-env planning artifacts. Never select automatically for implementation or review requests.'
---

# spec-iterate — orchestrate milestone completion

Run only on explicit user invocation. This authorizes sequential sub-agents and
the role switches below within the selected milestones. The parent coordinates,
handles decisions according to the chosen interaction mode, and reports results;
delegate all project inspection, implementation, verification, review, and
artifact edits to sub-agents. Never do their work in the parent or let workers
delegate further.

Honor [spec-env](../spec-env/SKILL.md) for planning and artifact semantics,
[spec-exec](../spec-exec/SKILL.md) for every implementation step, and
[spec-review](../spec-review/SKILL.md) for every review step. These skills retain
their ownership rules, including their dependency on
[code-quality](../code-quality/SKILL.md). Non-interactive mode delegates
decisions within agreed milestone scope to the parent. The user retains the
scope decisions described below in every mode.

## 1. Establish the starting state

Before asking for execution settings, spawn one read-only preflight sub-agent
with fresh context. Read-only state-check, planning-update, and artifact-maintenance
agents use the parent's model and effort; the user selects implementation and
review settings afterward. Give the preflight agent the project path and
dependency skill paths. Have it read those skills and inspect:

- Agreed `SPEC.md` and ordered `MILESTONES.md`, including scope, acceptance
  criteria, required verification, Done / Tested / Reviewed, and Current work.
- Any `REVIEW.md`, mapping findings to milestones and distinguishing unresolved
  findings awaiting fixes from fixes already handed back for verification.
- Actual files and Git state/history, including the current and default branches,
  to check stale progress notes, later changes to reviewed work, and evidence of
  previous implementation/review attempts.
- Any existing iteration decision ledger, including decisions awaiting user
  review and agreed amendments still requiring work.

Request a compact report of branch status, artifact readiness, milestone order
and state, pending findings, next role per unfinished milestone, blockers, and
supporting file/commit references. Inspection is not a review pass and must not
change files or mark any status. Wait for it to finish before proceeding.

If either planning artifact is missing, or affected planning is incomplete or
unagreed, report that `spec-iterate` cannot run and identify what must first be
resolved with `spec-env`. Do not create planning artifacts through this skill.
Missing dependency skills or unavailable sub-agent tools also block execution;
never substitute parent implementation or review.

## 2. Collect the user's choices

After preflight succeeds, ask two separate questions, one per role; they may be
presented together:

1. Which **model and thinking effort** should the implementer sub-agents use?
2. Which **model and thinking effort** should the reviewer sub-agents use?

Use the host's available model/effort combinations, without hardcoding a model
catalog or silently substituting settings. Validate both combinations against
the actual sub-agent tool. If the host cannot apply a requested combination,
explain the limitation and obtain a supported choice before execution.

Once both are answered, show the milestone states, pending review work, and
suggested starting role. Ask which milestones to cover, offering **All** or
**A specific range**. All means all remaining work in the existing plan; a
specific range requires explicit inclusive milestone IDs (a single ID is valid).
Also ask whether to run these milestones in **non-interactive mode**, explaining
that the coordinator will decide questions within agreed scope, keep a Markdown
decision ledger, and present it for user review after the last selected milestone passes.
These two questions may be presented together. An explicit instruction to run
the iteration in **non-interactive**, **silent**, or **afk** mode already answers
the mode question yes; do not ask it again. An explicit no selects interactive
mode. Honor choices already explicitly supplied for this run instead of asking again.
Wait for required answers; silence or a preselected option is not an answer.
The mode applies after execution setup; it does not supply missing model/effort
or milestone choices, or bypass discussions and agreement needed to establish
`SPEC.md` and `MILESTONES.md` through `spec-env`.

Resolve the selection in the plan's order. Skip milestones that have already
passed review. Route later changes and findings about their work through the
scope-change rules below.
Preserve review work outside the selection. Do not silently widen the range to
include prerequisites: if earlier unfinished work blocks the range under
`spec-env`, explain and ask for an adjusted selection or explicit order change
before execution. If the selection is already complete, skip milestone workers
and proceed to the completion, decision-review, and requested wrap-up gates.

State the resolved milestone queue, both model/effort pairs, interaction mode,
and starting role, then begin; this summary is not another approval gate.

## Set up the working branch

After read-only preflight and before the first file edit or commit, delegate a
branch check in the shared checkout. Apply the
[`spec-env` working branch rule](../spec-env/SKILL.md#choose-the-working-branch):
if the checkout is on the default branch, have the sub-agent create and switch
to a new task branch unless the user explicitly directs you to stay on the
default branch. Use the resulting branch for all worker assignments, including
ledger edits, planning updates, and wrap-up cleanup. Recheck the branch before
resuming writes after an interruption or checkout change.

## Handle changes to milestone scope

Workers report proposed changes outside their assigned scope before editing.
Plan new scope in a new milestone by default. Fixes needed to satisfy an
unreviewed milestone's existing criteria stay in that milestone, including
fixes from a failed review.

- Once a milestone has passed review, preserve its definition and status.
  Create a new milestone for any new change to its reviewed work.
- If the affected current milestone has yet to pass review, ask the user whether
  to include the change there or create a new milestone. Wait for their answer
  before changing the plan or dispatching the affected work, even in
  non-interactive mode. Honor a choice the user has already made.
- Only an explicit user instruction to make the specific change outside the
  milestone plan authorizes ad hoc work. In that case, give it separate
  implementation and review assignments identified by the user's request.
  Preserve existing milestone definitions and status.

Delegate agreed planning updates to a separate `spec-env` assignment under
[Change an established specification](../spec-env/SKILL.md#change-an-established-specification)
while milestone workers are paused. A new milestone enters the execution queue
only when the user includes it in the selection, even if they originally selected All.

## Non-interactive decisions and ledger

In interactive mode, surface questions and await required user answers as usual.
In non-interactive mode, workers send questions to the parent. For decisions
within agreed scope, the parent uses the agreed goal, constraints, project
artifacts, and available evidence. For a proposed scope change, follow the
milestone rules above. A coordinator decision or ledger entry cannot authorize
an amendment or ad hoc work.

Keep a persistent Markdown ledger at `DECISIONS.md` in the project root, or an
existing user-designated ledger path. Have a worker initialize it before
non-interactive execution, even if there are no decisions yet. Record every
decision made on the user's behalf before dependent work: decision ID, affected
milestone, question or ambiguity, chosen action, rationale and material tradeoffs,
and user-review status. Routine coding steps need no entry unless they settle
such a question. Keep decisions pending user review until the user actually
reviews them; autonomous execution and presentation do not constitute acceptance.
Delegate ledger edits to the current worker, or to a dedicated artifact-maintenance
sub-agent when no worker is active. Keep these assignments sequential and the
ledger separate from Current work and the milestone status table. It records
decisions; it does not replace the authoritative specification or review evidence.

Non-interactive mode does not waive required checks, independent review, the
failure/takeover limits below, or actual tool/permission limits. If no authorized
decision can unblock progress, record the blocker in the ledger and Current
work and stop affected work. Ask mid-run when the milestone rules require the
user's choice. Otherwise report the blocker without prompting.

## 3. Dispatch exactly one milestone and one worker at a time

Keep at most one sub-agent executing a step. Await its completion before any
next step; do not pipeline implementation, review, or different milestones.
Use a fresh implementer and a fresh, separate reviewer for each milestone,
creating each worker when its role is first needed. Prefer reusing that pair
through follow-up assignments for implementation, review, fixes, re-review, and
handoff repairs within that milestone only. Keep idle workers available between
those assignments; never assign them to another milestone. The parent may spawn
a replacement when a worker is unavailable or fresh context would help, subject
to the takeover rules below. Use the selected model and effort for each role.
New workers start without forked conversation history; where the host exposes
`fork_turns`, use `"none"`. Never silently inherit the wrong model or effort.

Use one shared project checkout so each step sees the preceding step's files
and commits. Preserve unrelated user changes. Workers must return at their
assigned handoff even though the parent has a larger milestone selection.
Use `SPEC.md`, `MILESTONES.md`, and `REVIEW.md` for handoffs between roles. Reused
workers may retain their own context, but must read the current artifacts and
check actual code and Git state on each assignment as their assigned skill
requires. Retained context does not replace current evidence. Load the role's
skills and dependencies initially; re-read relevant instructions when they
change or context is lost. Do not forward another worker's messages or
conversational summaries. The parent supplies the assignment and paths, not a
substitute narrative of the preceding work. Never assign review of changes to
an agent that implemented them.

For a milestone that has yet to pass review, route using verified state:

| State | Next step |
|-------|-----------|
| Implementation or required verification incomplete | Implementer using `spec-exec`, for this milestone only. |
| Done and Tested, awaiting review | Separate reviewer using `spec-review`, for this whole milestone. |
| Open findings awaiting fixes | Implementer using `spec-exec`, fixing this milestone's findings. |
| Fixes implemented and tested; re-review due | Separate reviewer using `spec-review`, verifying fixes and the whole milestone. |
| Current implementation, verification, and review all pass | Advance to the next selected milestone. |

Open findings with a verified fix handoff take the re-review route; the mere
presence of `REVIEW.md` must not cause another implementation attempt. Its
absence must not imply review passed. If status conflicts remain unresolved,
delegate a read-only state check before dispatching a mutating step.

After every worker returns, use its outcome to route the next step, and require
it to leave the workflow artifacts ready for the next worker. Reports are for
the parent and user; do not forward them between workers. Each worker checks
the current artifacts and actual code independently of the other role's report.
If an artifact handoff is incomplete, assign a repair to the responsible role,
preferably continuing with the same worker, with a read-only state check first
if needed. A repair alone does not reset or increment the failure counter.

Advance only after this milestone is Done, Tested, and Reviewed for the current
changes, with no unresolved findings for it. `REVIEW.md` may
remain for other milestones. Retire this milestone's workers, including any
takeover or replacement workers, before starting the next selected milestone
with a new pair. Carry project state forward through the artifacts and checkout.

## 4. Escalate after two unsuccessful attempts

Track consecutive failed **implementation attempts per milestone** in the
parent's orchestration context. The initial implementation counts: its first
review with actionable findings establishes failure 1. The implementer
then fixes the findings; if the reviewer still finds actionable issues,
that establishes failure 2. Count only distinct implementation/fix attempts
followed by review, not repeated inspections of the same unchanged code. A
missing check, interruption, or unresolved requirement is a blocker, not a
failed implementation attempt. Reusing or replacing a worker does not reset
the milestone's counter.

After failure 1, assign the first fix step to the implementer, then re-review
to the separate reviewer; both may be reused. After **failure 2**:

1. Retain the reviewer sub-agent that just reported the second failure. Once
   its review turn has finished, explicitly instruct that same agent to switch
   to the implementation role, load `spec-exec`, and fix this milestone's
   findings. Keep its reviewer-selected model and effort. This is the explicit
   exception to the usual separation of implementation and review roles.
2. Under `spec-exec`, that agent owns implementation and verification only. It
   must not edit/close findings, change Reviewed, or delete `REVIEW.md` while
   implementing, even though it previously acted as reviewer.
3. After its fixes and required checks, spawn a **new reviewer sub-agent** with
   the reviewer settings and `spec-review` to independently verify the results.
   The agent that made the fixes must not approve them.

For example: implementer → reviewer finds issues (failure 1) → same implementer
fixes findings → same reviewer finds issues (failure 2) → that reviewer switches
to `spec-exec` → new independent reviewer using `spec-review`.

If the independent review still finds issues after the takeover, stop this
milestone and report the remaining findings. Seek direction in interactive mode;
in non-interactive mode, record the blocker and stop without asking. Do not loop
through automatic takeovers indefinitely or advance to the next milestone.
Reset the counter when a milestone passes. On resumption, recover prior failed
attempts from available conversation, commits, and review evidence; do not infer
attempt counts from `REVIEW.md` existing. If the count cannot be established,
resolve it through the interaction-mode protocol instead of silently resetting
it. Do not guess a count or restart ordinary attempts without evidence; in
non-interactive mode, use a read-only check and stop with a recorded blocker if
it remains unknown. Keep counters in the orchestration handoff/context, without
adding tracking columns or an attempt journal or passing conversation history
to workers. If two failures are already established,
continue with the second reviewer for takeover rather than starting a third
ordinary implementer. If that reviewer is unavailable, report the blocker and
seek direction in interactive mode; in non-interactive mode, record the blocker
and stop without asking. Do not silently replace the required same-agent
continuation.

## Worker handoff contract

Include in each implementation/review dispatch:

- Project checkout and resolved paths to the required skills and artifacts.
- For milestone work, exactly one milestone ID and its assigned action, scope,
  acceptance criteria, and required verification in the planning artifacts. For
  explicitly authorized ad hoc work, supply the user's specific instruction
  and the checks for that change in place of a milestone ID and criteria.
- Explicit instruction to use `spec-exec` for implementation (including
  takeover fixes), or `spec-review` for review, with their dependencies. Load
  them initially and re-read when instructions change or context is lost.
- Instruction to read the assigned change's findings in `REVIEW.md` and the handoff,
  verification, and blockers in Current work, checking actual code and Git.
  Do not paste prior agents' findings or results into the prompt. For milestone
  work, review the whole milestone even when verifying particular fixes.
- Authorization for this single role only; no nested agents, self-review,
  automatic role switch, or work on the next milestone. The takeover is a
  separate explicit follow-up from the parent after the review turn ends.
- Instruction to maintain Current work and role-owned artifacts/commits as the
  assigned skill requires, preserving findings and progress outside this scope.
- Required return: milestone or ad hoc change, role, outcome (ready for review / findings remain /
  passed / blocked), files and commits, checks and results, remaining finding
  IDs, and the next action. Report new ambiguity or scope changes to the parent.
- Interaction mode and, for non-interactive runs, the ledger path. Return
  questions to the parent for its decision; record supplied decisions before
  acting and preserve their pending user-review status.

## Stop and report

Route worker questions through the scope-change and interaction-mode rules.
Resume affected milestone work when planning is ready and the selection remains
valid. Report unavailable verification or other blockers without marking
completion or repeatedly spawning workers.

On interruption, retain the selections, active milestone/role, failed-attempt
count, implementer and reviewer identities and their assigned milestone, any
takeover role change, and last worker outcome in the conversation handoff.
Also retain the interaction mode, ledger path and pending decision-review state,
and any explicit wrap-up request. Do not ask again for established settings.
Resume retained workers only for that same milestone. Ensure the active worker
has stopped before replacing it. Have it leave Current work accurate when
possible; recheck actual artifacts through a sub-agent on resumption.

When the selected queue passes, summarize milestones completed, verification,
remaining work outside the range, and any limitations. Completion of the range
is not completion of the entire plan. Only use `None — complete` in Current
work when all planned implementation and review have finished.

## Review decisions after the last milestone

After the last selected milestone has successfully passed review, present the
complete non-interactive decision ledger to the user, including rationale and
tradeoffs, and ask them to review its decisions. If the ledger is empty, report
that no autonomous decisions were needed; there are then no decisions awaiting
review. For a nonempty ledger, this is the required user checkpoint after
autonomous execution; do not silently accept decisions, infer acceptance from
silence, or treat the code review as decision review.

Record the user's feedback and which decisions they reviewed. Discuss any
requested amendments using the same scope-change rules. When adding a new
milestone, obtain the amended selection without re-asking unchanged model or
mode choices. This post-run discussion is interactive. Resume autonomous
execution within the agreed scope. Track amendment resolution separately from
decision-review status. Implement and independently review amendments using the
same iteration rules, then present any new or changed autonomous decisions for user review.
Keep planning artifacts until this checkpoint and any agreed amendment work
are complete.

## Wrap up only when requested

An explicit user request to wrap up the iteration authorizes cleanup once all
gates below hold; an earlier request remains sufficient without another approval.
Otherwise retain the artifacts when reporting completion.

Have a sub-agent verify current files, code, and review evidence before cleanup:

- All planned milestones, including follow-ups, are Done, Tested, and
  successfully Reviewed for their agreed scope. Completing a selected range
  with unfinished work elsewhere does not qualify.
- `REVIEW.md` is already absent because review has successfully completed.
  If it remains, return it to `spec-review` for proper resolution; never delete
  it as cleanup or treat its absence alone as proof of a pass.
- For a non-interactive iteration, the user has actually reviewed all ledger
  decisions and no requested amendments remain unresolved.

When these gates hold, delegate removal of at least `SPEC.md` and `MILESTONES.md`
to an artifact-maintenance sub-agent and commit the cleanup in a focused commit.
Preserve unrelated files and user changes. Retain the reviewed decision ledger
unless the user also requests its removal. Report the removed files and the
ledger's disposition. If a gate is unmet, retain the planning artifacts and
report what remains, using the chosen interaction mode for any execution blocker.
