# MILESTONES — <project name>

> Derived from `SPEC.md`. Implemented strictly in order, one after another.
> A milestone may begin only after the previous one is **Done** and **Tested**.
> Status legend: ✅ achieved · ⬜ not yet.

## Current work

- **Milestone:** M0 — <title>
- **Next action:** Implementer: <next action using spec-exec>
- **Blocker:** None
- **Verification:** Not run

## Tracking

| #   | Milestone                | Done | Tested | Reviewed |
|-----|--------------------------|:----:|:------:|:--------:|
| M0  | <scaffold / setup>       |  ⬜  |   ⬜   |    ⬜    |
| M1  | <first capability>       |  ⬜  |   ⬜   |    ⬜    |
| M2  | <next capability>        |  ⬜  |   ⬜   |    ⬜    |
| ... | ...                      |  ⬜  |   ⬜   |    ⬜    |

- **Done** — implemented.
- **Tested** — required verification passes.
- **Reviewed** — changes passed review with `spec-review`.

Advancing to the next milestone requires the current one to be **Done + Tested**.
The implementer maintains Done and Tested; the reviewer maintains Reviewed.
Reviewed may lag when the user requests continued implementation. Ticks record
completed passes; they do not certify later changes. Current work is a short,
replaceable snapshot checked against `SPEC.md` and Git when resuming.

---

## M0 — <title>

**Scope.** <What this milestone delivers. Keep it small enough to implement,
test, and review as one unit.>

**Acceptance criteria.**
- <criterion 1>
- <criterion 2>

**Required tests.**
- <test 1 — what it proves>
- <test 2>

---

## M1 — <title>

**Scope.** <...>

**Acceptance criteria.**
- <...>

**Required tests.**
- <...>

---

<Repeat one section per milestone, in implementation order.>
