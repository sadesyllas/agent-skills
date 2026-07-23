# REVIEW — open findings

> This file exists **only while there are open review findings**. When every
> milestone under review passes and its `Reviewed` column is ticked in
> `MILESTONES.md`, the reviewer deletes this file and commits its removal.
>
> **Reviewer-owned:** the coder may fix the referenced code, but must never edit
> finding statuses, mark findings resolved, tick `Reviewed`, delete this file,
> or commit its removal. Only the reviewer may perform those actions after
> verifying the fixes.

**Milestones under review:** <e.g. M0–M3>
**Reviewer:** <name / model>
**Date:** <date>

---

## M<n> — <milestone title>

### Finding 1 — <short title>
- **Severity:** blocker | major | minor
- **Where:** `path/to/file.ext:line` (or component / flow)
- **Problem:** <what is wrong and why it matters>
- **Required resolution:**
  1. <specific change to make>
  2. <other locations or instances of the same pattern to check>
  3. <test or observable result that proves the problem is resolved>
- **Repeated finding update:** <on re-review, if this remains or recurs, replace
  this placeholder with current evidence and explain why the attempted fix was
  insufficient; also revise the required-resolution steps to be clearer and
  more precise. Remove this field when the finding is first created or once it
  is resolved.>
- **Status:** ⬜ open | ✅ resolved

### Finding 2 — <short title>
- **Severity:**
- **Where:**
- **Problem:**
- **Required resolution:**
- **Repeated finding update:**
- **Status:** ⬜ open

---

## M<n+1> — <milestone title>

<Repeat per finding, grouped by milestone. The reviewer removes this file once
all findings are resolved and the affected `Reviewed` columns are ticked.>

> If a finding survives an attempted fix or the same underlying problem appears
> elsewhere, the reviewer must update its problem description, record why the
> attempted fix was insufficient, and provide clearer, ordered, verifiable
> resolution steps. Never return a repeated finding with stale instructions.
