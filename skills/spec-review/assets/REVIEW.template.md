# REVIEW — open findings

> Reviewer-owned. The implementer reads findings and fixes code; `spec-review`
> verifies closure, maintains Reviewed, and removes this file after all findings
> are resolved and the affected milestones or ad hoc changes pass review.
> Its absence alone does not prove review occurred. Git preserves review history.

**Review scope:** <milestone IDs or the explicitly authorized ad hoc change>
**Reviewer:** <name / model>
**Date:** <date>

## M<n> — <milestone title>

<For an explicitly authorized ad hoc change, use its description as the heading.>

### R1 — <short title; keep this ID on re-review>

- **Severity:** blocker | major | minor
- **Where:** `path/to/file.ext:line`
- **Problem:** <current evidence and concrete impact>
- **Resolution:** <required outcome and the check that demonstrates it>
- **Status:** open | resolved

<Repeat only for actual findings. If a finding recurs, replace stale evidence
and guidance, briefly explaining why the attempted fix was insufficient. Keep
resolved entries only while needed to finish this review; do not append a log.>
