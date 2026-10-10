---
name: spec-iterate
description: 'Orchestrate spec-exec and spec-review sub-agents through a selected milestone range. Use only when the user explicitly invokes spec-iterate; requires existing spec-env planning artifacts. Never select automatically for implementation or review requests.'
---

# spec-iterate — orchestrate milestone completion

Run only on explicit user invocation. This authorizes sequential sub-agents and
the role switches below within the selected milestones. The parent coordinates,
asks questions, and reports results; delegate all project inspection,
implementation, verification, review, and artifact edits to sub-agents. Never
do their work in the parent or let workers delegate further.

Honor [spec-env](../spec-env/SKILL.md) for planning and artifact semantics,
[spec-exec](../spec-exec/SKILL.md) for every implementation step, and
[spec-review](../spec-review/SKILL.md) for every review step. These skills retain
their ownership rules, including their dependency on
[code-quality](../code-quality/SKILL.md). Do not copy or relax those rules.

## 1. Establish the starting state

Before asking for execution settings, spawn one read-only preflight sub-agent
with fresh context. Read-only state-check agents use the parent's model and
effort; the user selects implementation and review settings afterward. Give it
the project path and dependency skill paths. Have it read those skills and inspect:

- Agreed `SPEC.md` and ordered `MILESTONES.md`, including scope, acceptance
  criteria, required verification, Done / Tested / Reviewed, and Current work.
- Any `REVIEW.md`, mapping findings to milestones and distinguishing unresolved
  findings awaiting fixes from fixes already handed back for verification.
- Actual files and Git state/history to check stale progress notes, later
  changes to reviewed work, and evidence of previous implementation/review attempts.

Request a compact report of artifact readiness, milestone order and state,
pending findings, next role per unfinished milestone, blockers, and supporting
file/commit references. Inspection is not a review pass and must not change
files or mark any status. Wait for it to finish before proceeding.

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
Honor choices already explicitly supplied for this run instead of asking again.
Wait for required answers; silence or a preselected option is not an answer.

Resolve the selection in the plan's order. Skip milestones whose Done, Tested,
and Reviewed remain valid for the current code. A review tick invalidated by
later changes or unresolved findings does not make a milestone complete.
Preserve review work outside the selection. Do not silently widen the range to
include prerequisites: if earlier unfinished work blocks the range under
`spec-env`, explain and ask for an adjusted selection or explicit order change.
If the selection is already complete, report that and finish without workers.

State the resolved milestone queue, both model/effort pairs, and starting role,
then begin; this summary is not another approval gate.

## 3. Dispatch exactly one milestone and one worker at a time

Keep at most one sub-agent active. Await its completion before any next step;
do not pipeline implementation, review, or different milestones. Spawn a fresh
sub-agent with fresh context for each step, using the selected model and effort
for its role. Do not fork conversation history, even when two workers use the
same model. Where the host exposes `fork_turns`, use `"none"`. Never silently
inherit the wrong model or effort.

Use one shared project checkout so each step sees the preceding step's files
and commits. Preserve unrelated user changes. Workers must return at their
assigned handoff even though the parent has a larger milestone selection.
Transfer workflow context between steps only through `SPEC.md`, `MILESTONES.md`,
and `REVIEW.md`. Do not forward previous worker messages or conversational
summaries. Each worker reads these artifacts and checks the actual code and Git
state as its assigned skill requires. The parent supplies the assignment and
paths, not a substitute narrative of the preceding work.

For the current milestone, route using verified state:

| State | Next step |
|-------|-----------|
| Implementation or required verification incomplete | Fresh implementer using `spec-exec`, for this milestone only. |
| Done and Tested; review due, absent, or invalidated | Fresh reviewer using `spec-review`, for this whole milestone. |
| Open findings awaiting fixes | Fresh implementer using `spec-exec`, fixing this milestone's findings. |
| Fixes implemented and tested; re-review due | Fresh reviewer using `spec-review`, verifying fixes and the whole milestone. |
| Current implementation, verification, and review all pass | Advance to the next selected milestone. |

Open findings with a verified fix handoff take the re-review route; the mere
presence of `REVIEW.md` must not cause another implementation attempt. Its
absence must not imply review passed. If status conflicts remain unresolved,
delegate a read-only state check before dispatching a mutating step.

After every worker returns, use its outcome to route the next step, and require
it to leave the workflow artifacts ready for the next worker. Reports are for
the parent and user; do not forward them as worker context. Each new worker
reads the artifacts and actual code independently. If an artifact handoff is
incomplete, use a fresh worker of the responsible role to repair it, with a
read-only state check first if needed. Do not resume the previous worker for
this; only the takeover below permits reuse.

Advance only after this milestone is Done, Tested, and Reviewed for the current
changes, with no unresolved findings for it. `REVIEW.md` may
remain for other milestones. This orchestration completes each milestone's
review before starting the next selected milestone.

## 4. Escalate after two unsuccessful attempts

Track consecutive failed **implementation attempts per milestone** in the
parent's orchestration context. The initial implementation counts: its first
review with actionable findings establishes failure 1. A fresh implementer
then fixes the findings; if a fresh reviewer still finds actionable issues,
that establishes failure 2. Count only distinct implementation/fix attempts
followed by review, not repeated inspections of the same unchanged code. A
missing check, interruption, or unresolved requirement is a blocker, not a
failed implementation attempt.

After failure 1, spawn a fresh implementer for the first fix step, then a fresh
reviewer. After **failure 2**:

1. Retain the reviewer sub-agent that just reported the second failure. Once
   its review turn has finished, explicitly instruct that same agent to switch
   to the implementation role, load `spec-exec`, and fix this milestone's
   findings. Keep its reviewer-selected model and effort; reusing its context
   here is the sole exception to the fresh-agent rule.
2. Under `spec-exec`, that agent owns implementation and verification only. It
   must not edit/close findings, change Reviewed, or delete `REVIEW.md` while
   implementing, even though it previously acted as reviewer.
3. After its fixes and required checks, spawn a **new reviewer sub-agent** with
   the reviewer settings and `spec-review` to independently verify the results.
   The agent that made the fixes must not approve them.

For example: fresh initial implementer → fresh review with findings (failure 1)
→ fresh implementer fixing findings → fresh review with findings (failure 2)
→ that reviewer switches to `spec-exec` → fresh independent `spec-review`.

If the independent review still finds issues after the takeover, stop this
milestone and report the remaining findings for user direction; do not loop
through automatic takeovers indefinitely or advance to the next milestone.
Reset the counter when a milestone passes. On resumption, recover prior failed
attempts from available conversation, commits, and review evidence; do not infer
attempt counts from `REVIEW.md` existing. If the count cannot be established,
ask instead of silently resetting it. Keep counters in the orchestration
handoff/context, without adding tracking columns or project journals or passing
conversation history to workers. If two failures are already established,
continue with the second reviewer for takeover rather than starting a third
ordinary implementer. If that reviewer is unavailable, report the blocker and
ask for direction; do not silently replace the required same-agent continuation.

## Worker handoff contract

Include in each implementation/review dispatch:

- Project checkout and resolved paths to the required skills and artifacts.
- Exactly one milestone ID and the assigned action. Direct the worker to that
  milestone's scope, acceptance criteria, and required verification in the
  planning artifacts; do not give it the whole selected range as an assignment.
- Explicit instruction to load `spec-exec` for implementation (including
  takeover fixes), or `spec-review` for review. Load their dependencies too.
- Instruction to read this milestone's findings in `REVIEW.md` and the handoff,
  verification, and blockers in Current work, checking actual code and Git.
  Do not paste prior agents' findings or results into the prompt. Review scope
  remains the whole milestone even when verifying particular fixes.
- Authorization for this single role only; no nested agents, self-review,
  automatic role switch, or work on the next milestone. The takeover is a
  separate explicit follow-up from the parent after the review turn ends.
- Instruction to maintain Current work and role-owned artifacts/commits as the
  assigned skill requires, preserving findings and progress outside this scope.
- Required return: milestone, role, outcome (ready for review / findings remain /
  passed / blocked), files and commits, checks and results, remaining finding
  IDs, and the next action. Report new ambiguity or scope changes to the parent.

## Stop and report

Surface worker questions to the user and await required answers. If a spec
change is needed, stop affected work for the `spec-env` change protocol; do not
invent requirements or let a worker expand the plan. Resume only when planning
is ready and the selection remains valid. Report unavailable verification or
other blockers without marking completion or repeatedly spawning workers.

On interruption, retain the selections, active milestone/role, failed-attempt
count, and last worker identity/outcome in the conversation handoff. Ensure the active
worker has stopped before replacing it. Have it leave Current work accurate
when possible; recheck actual artifacts through a sub-agent on resumption.

When the selected queue passes, summarize milestones completed, verification,
remaining work outside the range, and any limitations. Completion of the range
is not completion of the entire plan. Only use `None — complete` in Current
work when all planned implementation and review have finished.
