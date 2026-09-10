---
name: code-quality
description: 'Shared standards for writing and reviewing production code: enforce DRY, document contracts and non-obvious behavior, and follow language and project conventions. Applies independently of the planning and milestone workflow.'
---

# code-quality — shared engineering standards

These standards apply during implementation and review. They do not assign a
workflow role. Follow explicit user requirements and project-specific conventions.

## Enforce DRY

DRY is a requirement, not an optional preference. Each production business rule
and repeated non-trivial behavior must have one maintained implementation.
Before adding logic, look for an existing implementation to reuse or extend.
Consolidate duplicated logic, query behavior, and change-sensitive boilerplate;
do not leave copies that must be kept in sync.

Share actual behavior, not merely similar-looking syntax. Do not couple unrelated
concepts or introduce speculative abstractions to eliminate incidental repetition.
Simple test setup and assertions may repeat when sharing would hide test intent;
tests must still reuse maintained test helpers where useful and must not copy
production algorithms to calculate their expected results. Generated code is
maintained through its generator, not manual deduplication.

## Document useful contracts

Document public API contracts and non-obvious behavior: inputs, results, failures,
side effects, and constraints as relevant. Explain complex flows and decisions
where a reader needs context. Avoid comments that merely repeat a declaration.
Use the project's documentation conventions; stricter requirements for every
type or member belong in the project specification.

## Follow language and project conventions

Keep code idiomatic, readable, and focused. Use file organization appropriate to
the language and surrounding project. For C#, default to one top-level type per
file with a matching name; nested types, partial types, generated files, and
entry-point statements are exceptions. Do not impose this layout on all languages.

Apply these standards while working and check them before handoff. Refer to this
skill from other skills instead of copying or repeatedly announcing its rules.
