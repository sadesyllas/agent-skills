# SPEC — <project name>

> The single source of truth for this project. Code conforms to this document.
> Any change to architecture, components, contracts, or behavior is reflected
> here **first**, then committed, then implemented.

## 1. Purpose and structure

<What the project is for. The problem it solves. Who/what consumes it. The
high-level structure: solution/repo layout, top-level projects or packages, and
how they fit together.>

## 2. Components

<Each module / service / project and its single responsibility. A short table or
list. Note ownership boundaries and the public surface of each component.>

| Component | Responsibility | Public surface |
|-----------|----------------|----------------|
|           |                |                |

## 3. Dependencies

<Runtimes, frameworks, and libraries with intended versions. Build and test
tooling. Anything external the project pulls in. State why each non-trivial
dependency is chosen.>

## 4. Telemetry

<How observability is produced and emitted: logging (e.g. Serilog), tracing and
metrics (e.g. OpenTelemetry), correlation IDs, log sinks/exporters, and the
events/spans/metrics that matter. State the minimum telemetry every component
must emit.>

## 5. System interactions

<How this software talks to other systems: inbound and outbound APIs, message
buses/topics, databases and stores, third-party services. Protocols, data
contracts/schemas, retry/idempotency expectations, and failure handling.>

---

## Commitments

These are binding requirements for the implementation, not aspirations.

### 6. Authentication & authorization

<What must be authenticated, what must be authorized, and how it is enforced
(mechanisms, scopes/roles, token flow). State "none required" explicitly only if
that is a deliberate decision.>

### 7. Performance characteristics

<Required latency, throughput, concurrency, and resource limits. State the
targets that must be met and how they will be measured.>

### 8. Full testing coverage

The system must be **thoroughly tested**. Define the required test types (unit,
integration, contract, end-to-end as applicable), what "thorough" means for this
project, and the gate: no untested code advances.

### 9. DRY

The DRY (Don't Repeat Yourself) principle is honored **absolutely**. No
duplicated logic, boilerplate, or query patterns across handlers, repositories,
or tests. Repeated logic is abstracted into reusable helpers, extensions, or
shared classes.

### 10. Coding standards

The highest coding standards are upheld: idiomatic, readable, consistent,
maintainable code that matches the conventions of the surrounding codebase.

### 11. Documentation

Documentation is **mandatory**, especially for public APIs and complex flows.
<State the doc convention, e.g. XML doc comments on every public type and member;
plus narrative docs for non-obvious flows.>

---

## Change log

<Append an entry whenever this spec changes: date, what changed, and — for
non-trivial changes — the shift in logic and why.>

| Date | Change | Reason / logic shift |
|------|--------|----------------------|
|      |        |                      |
